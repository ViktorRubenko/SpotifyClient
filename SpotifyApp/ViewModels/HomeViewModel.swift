//
//  HomeViewModel.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 12.03.2022.
//

import Foundation
import UIKit
import Alamofire

struct BrowseSection {
    let title: String
    let items: [CellModel]
}

final class HomeViewModel {
    
    private(set) var sections = Observable<[BrowseSection]>([])
    private(set) var error: AFError?
    
    init() {}
    
    func fetchData() {
        
        var featuredPlaylists = [FeaturesPlaylistCellModel]()
        var newReleases = [NewReleasesCellModel]()
        var recommendationTracks = [RecommendationTrackCellModel]()
        
        let group = DispatchGroup()
        
        group.enter()
        APICaller.shared.getNewReleases { [weak self] result in
            switch result {
            case .success(let response):
                newReleases = response.albums.items.compactMap { album in
                    NewReleasesCellModel(
                        name: album.name,
                        imageURL: findClosestSizeImage(images: album.images, height: 250, width: 250),
                        artistsName: album.artists.compactMap({$0.name}).joined(separator: ", "))
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
                    FeaturesPlaylistCellModel(
                        name: playlist.name,
                        imageURL: findClosestSizeImage(images: playlist.images, height: 300, width: 300))
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
                    RecommendationTrackCellModel(
                        name: track.name,
                        type: track.type.capitalized,
                        albumImageURL: findClosestSizeImage(images: track.album.images, height: 70, width: 70),
                        artistsName: track.artists.compactMap({$0.name}).joined(separator: ", "))
                }
            case .failure(let error):
                self?.error = error
            }
            group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
            var tempSections = [BrowseSection]()
            tempSections.append(BrowseSection(
                title: "New Releases",
                items: newReleases))
            tempSections.append(BrowseSection(
                title: "Featured Playlists",
                items: featuredPlaylists))
            tempSections.append(BrowseSection(
                title: "Recommendations",
                items: recommendationTracks))
            self?.sections.value = tempSections
        }
    }
}
