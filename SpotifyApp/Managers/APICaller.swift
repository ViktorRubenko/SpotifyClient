//
//  APICaller.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 10.03.2022.
//

import Foundation
import Alamofire

enum SpotifySearchTypes: String {
    case album, artist, playlist, track
    case all = "track,album,artist,playlist"
}

class APICaller {
    static let shared = APICaller()
    
    private let baseURL = "https://api.spotify.com/v1"
    
    enum UsersTopItemsType: String {
        case artists, tracks
    }
    
    private init() {}
    
    private func createRequest(url: String, method: HTTPMethod ,parameters: [String: String] = [:], completion: @escaping (DataRequest) -> Void) {
        AuthManager.shared.withValidToken { accessToken in
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(accessToken)",
                "Content-Type": "application/json"
            ]
            let request = AF.request(url, method: method, parameters: parameters, encoder: .urlEncodedForm, headers: headers)
            completion(request)
        }
    }
    
    func getCurrentUserProfile(completion: @escaping (Result<UserProfileResponse, AFError>) -> Void) {
        createRequest(
            url: baseURL + "/me",
            method: .get) { dataRequest in
                dataRequest.responseDecodable(of: UserProfileResponse.self) { response in
                    completion(response.result)
                }
            }
    }
    
    func getNewReleases(limit: Int = 30, completion: @escaping (Result<NewReleasesResponse, AFError>) -> Void) {
        createRequest(
            url: baseURL + "/browse/new-releases?limit=\(limit)",
            method: .get) { dataRequest in
                dataRequest.responseDecodable(of: NewReleasesResponse.self) { response in
                    completion(response.result)
                }
            }
    }
    
    func getFeaturedPlalists(limit: Int = 30, completion: @escaping (Result<PlaylistsResponse, AFError>) -> Void) {
        createRequest(
            url: baseURL + "/browse/featured-playlists?limit=\(limit)",
            method: .get) { dataRequest in
                dataRequest.responseDecodable(of: PlaylistsResponse.self) { response in
                    completion(response.result)
                }
            }
    }
    
    func getUsersTopArtists(completion: @escaping (Result<UsersTopArtistsResponse, AFError>) -> Void) {
        createRequest(
            url: baseURL + "/me/top/artists",
            method: .get) { dataRequest in
                dataRequest.responseDecodable(of: UsersTopArtistsResponse.self) { response in
                    completion(response.result)
                }
            }
    }
    
    func getUsersTopTracks(completion: @escaping
                           (Result<UsersTopTracksResponse, AFError>) -> Void) {
        createRequest(url: baseURL + "/me/top/tracks", method: .get) { dataRequest in
            dataRequest.responseDecodable(of: UsersTopTracksResponse.self) { response in
                completion(response.result)
            }
        }
    }
    
    func getRecommendations(limit: Int = 5, completion: @escaping (Result<RecommendationsResponse, AFError>) -> Void) {
        var seed_artists = ""
        var seed_tracks = ""
        var seed_genres = ""
        
        let seedGroup = DispatchGroup()
        
        seedGroup.enter()
        DispatchQueue.global(qos: .utility).async { [weak self] in
            self?.getUsersTopArtists { result in
                switch result {
                case .success(let artistsResponse):
                    seed_artists = artistsResponse.items[0].id
                    seed_genres = artistsResponse.items[0].id
                case .failure(let error):
                    completion(.failure(error))
                    return
                }
                seedGroup.leave()
            }
        }
        
        seedGroup.enter()
        DispatchQueue.global(qos: .utility).async { [weak self] in
            self?.getUsersTopTracks { result in
                switch result {
                case .success(let tracksResponse):
                    let tracks = tracksResponse.items
                    let lenght = tracks.count >= 2 ? 2 : tracks.count
                    seed_tracks = tracksResponse.items[0...lenght].compactMap({$0.id}).joined(separator: ",")
                case .failure(let error):
                    completion(.failure(error))
                    return
                }
                seedGroup.leave()
            }
        }
        
        seedGroup.notify(queue: .global()) { [weak self] in
            let url = (
                self!.baseURL + "/recommendations?seed_artits=\(seed_artists)" +
                "&seed_genres=\(seed_genres)&seed_tracks=\(seed_tracks)&limit=\(limit)"
            ).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            
            self!.createRequest(
                url: url,
                method: .get) { dataRequest in
                    dataRequest.responseDecodable(of: RecommendationsResponse.self) { response in
                        completion(response.result)
                    }
                }
        }
    }
    
    func getAlbum(id: String, completion: @escaping (Result<AlbumDetailResponse, AFError>) -> Void) {
        createRequest(url: baseURL + "/albums/\(id)", method: .get) { dataRequest in
            dataRequest.responseDecodable(of: AlbumDetailResponse.self) { response in
                completion(response.result)
            }
        }
    }
    
    func searchRequest(
        _ query: String,
        type: SpotifySearchTypes = .all,
        limit: Int = 50,
        offset: Int = 0,
        completion: @escaping (Result<SearchResponse, AFError>) -> Void) {
            createRequest(
                url: baseURL + "/search?limit=\(limit)&offset=\(offset)&q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)&type=\(type.rawValue)",
                method: .get) { dataRequest in
                    dataRequest.responseDecodable(of: SearchResponse.self) { response in
                        completion(response.result)
                    }
                }
        }
    
    func getRecentlyPlayedTracks(limit: Int = 20, completion: @escaping (Result<RecentlyPlayedResponse, AFError>) -> Void) {
        createRequest(url: baseURL + "/me/player/recently-played?limit=\(limit)", method: .get) { dataRequest in
            dataRequest.responseDecodable(of: RecentlyPlayedResponse.self) { response in
                completion(response.result)
            }
        }
    }
    
    func getTrack(id: String, completion: @escaping (Result<TrackResponse, AFError>) -> Void) {
        createRequest(url: baseURL + "/tracks/\(id)", method: .get) { dataRequest in
            dataRequest.responseDecodable(of: TrackResponse.self) { response in
                completion(response.result)
            }
        }
    }
    
    func getPlaylist(id: String, completion: @escaping (Result<PlaylistDetailResponse, AFError>) -> Void) {
        createRequest(url: baseURL + "/playlists/\(id)", method: .get) { dataRequest in
            dataRequest.responseDecodable(of: PlaylistDetailResponse.self) { response in
                completion(response.result)
            }
        }
    }
    
    func getCategories(limit: Int = 20, completion: @escaping (Result<CategoriesResponse,AFError>) -> Void) {
        createRequest(url: baseURL + "/browse/categories?limit=\(limit)", method: .get) { dataRequest in
            dataRequest.responseDecodable(of: CategoriesResponse.self) { response in
                completion(response.result)
            }
        }
    }
    
    func getCategoryPlaylists(id: String, limit: Int = 20, completion: @escaping (Result<PlaylistsResponse,AFError>) -> Void) {
        createRequest(url: baseURL + "/browse/categories/\(id)/playlists?limit=\(limit)", method: .get) { dataRequest in
            dataRequest.responseDecodable(of: PlaylistsResponse.self) { response in
                completion(response.result)
            }
        }
    }
    
    func getArtist(id: String, completion: @escaping (Result<ArtistDetailResponse,AFError>) -> Void) {
        createRequest(url: baseURL + "/artists/\(id)", method: .get) { dataRequest in
            dataRequest.responseDecodable(of: ArtistDetailResponse.self) { response in
                completion(response.result)
            }
        }
    }
    
    func getArtistsTopTracks(id: String, completion: @escaping (Result<ArtistsTopTracksResponse,AFError>) -> Void) {
        let market = Locale.current.regionCode ?? "US"
        createRequest(url: baseURL + "/artists/\(id)/top-tracks?market=\(market)", method: .get) { dataRequest in
            dataRequest.responseDecodable(of: ArtistsTopTracksResponse.self) { response in
                completion(response.result)
            }
        }
    }
    
    func getArtistAlbums(id: String, limit: Int = 50, completion: @escaping (Result<ArtistsAlbumsResponse,AFError>) -> Void) {
        createRequest(url: baseURL + "/artists/\(id)/albums", method: .get) { dataRequest in
            dataRequest.responseDecodable(of: ArtistsAlbumsResponse.self) { response in
                completion(response.result)
            }
        }
    }
}
