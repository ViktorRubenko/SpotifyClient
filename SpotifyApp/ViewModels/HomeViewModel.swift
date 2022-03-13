//
//  HomeViewModel.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 12.03.2022.
//

import Foundation
import UIKit
import Alamofire

enum HomeSectionType: Int {
    
    static var allCases: [HomeSectionType] {
        [.userPlaylists, .recentlyPlayed, .newReleases, .featuredPlaylists, .recommendations, .unknown]
    }
    
    case userPlaylists, recentlyPlayed, newReleases, featuredPlaylists, recommendations, unknown
    
    init(fromRawValue: Int) {
        self = HomeSectionType(rawValue: fromRawValue) ?? .unknown
    }
}

struct HomeSection {
    let type: HomeSectionType
    let title: String
    let items: [CellModel]
}

final class HomeViewModel {
    
    private(set) var sections = Observable<[HomeSection]>([])
    private(set) var error: AFError?
    
    init() {}
    
    func fetchData() {
        
        var userPlaylists = [PlaylistModel]()
        var recentlyPlayedTracks = [TrackModel]()
        var featuredPlaylists = [PlaylistModel]()
        var newReleases = [AlbumModel]()
        var recommendationTracks = [TrackModel]()
        
        let group = DispatchGroup()
        
        group.enter()
        APICaller.shared.searchRequest("Discover Weekly", type: .playlist, limit: 1) { [weak self] result in
            switch result {
            case .success(let response):
                userPlaylists = response.playlists!.items.compactMap { playlist in
                    PlaylistModel(
                        name: playlist.name,
                        imageURL: findClosestSizeImage(images: playlist.images, height: 70, width: 70),
                        id: playlist.id)
                }
            case .failure(let error):
                self?.error = error
            }
            group.leave()
        }
        
        group.enter()
        APICaller.shared.searchRequest("Liked Songs", type: .playlist, limit: 1) { [weak self] result in
            switch result {
            case .success(let response):
                userPlaylists += response.playlists!.items.compactMap { playlist in
                    PlaylistModel(
                        name: playlist.name,
                        imageURL: findClosestSizeImage(images: playlist.images, height: 70, width: 70),
                        id: playlist.id)
                }
            case .failure(let error):
                self?.error = error
            }
            group.leave()
        }
        
        group.enter()
        APICaller.shared.getRecentlyPlayedTracks { result in
            switch result {
            case .success(let tracksResponse):
                recentlyPlayedTracks = tracksResponse.items.compactMap {
                    TrackModel(
                        name: $0.track.name,
                        type: $0.track.type,
                        albumImageURL: findClosestSizeImage(images: $0.track.album.images, height: 200, width: 200),
                        artistsName: $0.track.artists.compactMap({$0.name}).joined(separator: ", "),
                        id: $0.track.id)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            group.leave()
        }
        
        group.enter()
        APICaller.shared.getNewReleases { [weak self] result in
            switch result {
            case .success(let response):
                newReleases = response.albums.items.compactMap { album in
                    AlbumModel(
                        name: album.name,
                        imageURL: findClosestSizeImage(images: album.images, height: 250, width: 250),
                        artistsName: album.artists.compactMap({$0.name}).joined(separator: ", "),
                        id: album.id)
                }
                print("Get NewReleases")
            case .failure(let error):
                self?.error = error
            }
            group.leave()
        }
        
        group.enter()
        APICaller.shared.getFeaturedPlalists { [weak self] result in
            switch result {
            case .success(let response):
                featuredPlaylists = response.playlists.items.compactMap { playlist in
                    PlaylistModel(
                        name: playlist.name,
                        imageURL: findClosestSizeImage(images: playlist.images, height: 300, width: 300),
                        id: playlist.id)
                }
                print("Get FeaturedPlaylists")
            case .failure(let error):
                self?.error = error
                print(error)
            }
            group.leave()
        }
        
        group.enter()
        APICaller.shared.getRecommendations(limit: 10) { [weak self] result in
            switch result {
            case .success(let response):
                recommendationTracks = response.tracks.compactMap { track in
                    TrackModel(
                        name: track.name,
                        type: track.type.capitalized,
                        albumImageURL: findClosestSizeImage(images: track.album.images, height: 250, width: 250),
                        artistsName: track.artists.compactMap({$0.name}).joined(separator: ", "),
                        id: track.id)
                }
            case .failure(let error):
                self?.error = error
            }
            group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
            var tempSections = [HomeSection]()
            tempSections.append(HomeSection(
                type: .userPlaylists,
                title: "",
                items: userPlaylists))
            tempSections.append(HomeSection(
                type: .recentlyPlayed,
                title: "Recently Played",
                items: recentlyPlayedTracks))
            tempSections.append(HomeSection(
                type: .newReleases,
                title: "New Releases",
                items: newReleases))
            tempSections.append(HomeSection(
                type: .featuredPlaylists,
                title: "Featured Playlists",
                items: featuredPlaylists))
            tempSections.append(HomeSection(
                type: .recommendations,
                title: "Recommendations",
                items: recommendationTracks))
            self?.sections.value = tempSections
        }
    }
}
