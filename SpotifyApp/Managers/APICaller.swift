//
//  APICaller.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 10.03.2022.
//

import Foundation
import Alamofire

class APICaller {
    static let shared = APICaller()
    
    private let baseURL = "https://api.spotify.com/v1"
    
    enum UsersTopItemsType: String {
        case artists, tracks
    }
    
    private init() {}
    
    
    func getCurrentUserProfile(completion: @escaping (Result<UserProfile, AFError>) -> Void) {
        createRequest(
            url: baseURL + "/me",
            method: .get) { dataRequest in
                dataRequest.responseDecodable(of: UserProfile.self) { response in
                    completion(response.result)
                }
            }
    }
    
    func getNewReleases(limit: Int = 50, completion: @escaping (Result<NewReleasesResponse, AFError>) -> Void) {
        createRequest(
            url: baseURL + "/browse/new-releases?limit=\(limit)",
            method: .get) { dataRequest in
                dataRequest.responseDecodable(of: NewReleasesResponse.self) { response in
                    completion(response.result)
                }
            }
    }
    
    func getFeaturedPlalists(limit: Int = 50, completion: @escaping (Result<FeaturedPlaylistsResponse, AFError>) -> Void) {
        createRequest(
            url: baseURL + "/browse/featured-playlists?limit=\(1)",
            method: .get) { dataRequest in
                dataRequest.responseDecodable(of: FeaturedPlaylistsResponse.self) { response in
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
    
    func getRecommendations(completion: @escaping (Result<RecommendationsResponse, AFError>) -> Void) {
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
                "&seed_genres=\(seed_genres)&seed_tracks=\(seed_tracks)"
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
}
