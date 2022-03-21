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
    let items: [ItemModel]
}

final class HomeViewModel {
    
    private(set) var sections = Observable<[HomeSection]>([])
    private(set) var error: AFError?
    
    init() {}
    
    func fetchData() {
        
        var userPlaylists = [ItemModel]()
        var recentlyPlayedTracks = [ItemModel]()
        var featuredPlaylists = [ItemModel]()
        var newReleases = [ItemModel]()
        var recommendationTracks = [ItemModel]()
        
        let group = DispatchGroup()
        
        group.enter()
        APICaller.shared.searchRequest("Discover Weekly", type: .playlist, limit: 1) { [weak self] result in
            switch result {
            case .success(let response):
                userPlaylists += response.playlists!.items.compactMap {
                    ItemModel(
                        id: $0.id,
                        name: $0.name,
                        info: $0.owner?.displayName,
                        imageURL: findClosestSizeImage(images: $0.images, height: 70, width: 70),
                        itemType: .playlist)
                }
            case .failure(let error):
                print(error.localizedDescription)
                self?.error = error
            }
            group.leave()
        }
        
        group.enter()
        APICaller.shared.searchRequest("Release Radar", type: .playlist, limit: 1) { [weak self] result in
            switch result {
            case .success(let response):
                userPlaylists += response.playlists!.items.compactMap { playlist in
                    ItemModel(
                        id: playlist.id,
                        name: playlist.name,
                        info: playlist.owner?.displayName ?? "",
                        imageURL: findClosestSizeImage(images: playlist.images, height: 70, width: 70),
                        itemType: .playlist)
                }
            case .failure(let error):
                print(error.localizedDescription)
                self?.error = error
            }
            group.leave()
        }
        
        group.enter()
        APICaller.shared.getRecentlyPlayedTracks { result in
            switch result {
            case .success(let tracksResponse):
                recentlyPlayedTracks = tracksResponse.items.compactMap {
                    ItemModel(
                        id: $0.track.id,
                        name: $0.track.name,
                        info: $0.track.artists.compactMap({$0.name}).joined(separator: ", "),
                        imageURL: findClosestSizeImage(images: $0.track.album!.images, height: 200, width: 200),
                        itemType: .track)
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
                    ItemModel(
                        id: album.id,
                        name: album.name,
                        info: album.artists.compactMap({$0.name}).joined(separator: ", "),
                        imageURL: findClosestSizeImage(images: album.images, height: 250, width: 250),
                        itemType: .album)
                }
                print("Get NewReleases")
            case .failure(let error):
                print(error)
                print(error.localizedDescription)
                self?.error = error
            }
            group.leave()
        }
        
        group.enter()
        APICaller.shared.getFeaturedPlalists { [weak self] result in
            switch result {
            case .success(let response):
                featuredPlaylists = response.playlists.items.compactMap { playlist in
                    ItemModel(
                        id: playlist.id,
                        name: playlist.name,
                        info: playlist.owner?.displayName ?? "",
                        imageURL: findClosestSizeImage(images: playlist.images, height: 300, width: 300),
                        itemType: .playlist)
                }
                print("Get FeaturedPlaylists")
            case .failure(let error):
                self?.error = error
                print(error)
                print(error.localizedDescription)
            }
            group.leave()
        }
        
        group.enter()
        APICaller.shared.getRecommendations(limit: 10) { [weak self] result in
            switch result {
            case .success(let response):
                recommendationTracks = response.tracks.compactMap { track in
                    ItemModel(
                        id: track.id,
                        name: track.name,
                        info: track.artists.compactMap({$0.name}).joined(separator: ", "),
                        imageURL: findClosestSizeImage(images: track.album!.images, height: 250, width: 250),
                        itemType: .track)
                }
            case .failure(let error):
                print(error.localizedDescription)
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
