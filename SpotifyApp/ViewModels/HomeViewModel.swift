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
        
        var featuredPlaylists = [NewReleasesCellModel]()
        
        let group = DispatchGroup()
        
        group.enter()
        APICaller.shared.getNewReleases { [weak self] result in
            switch result {
            case .success(let newReleases):
                featuredPlaylists = newReleases.albums.items.compactMap { album in
                    NewReleasesCellModel(
                        name: album.name,
                        imageURL: URL(string: album.images.first?.url ?? ""),
                        numberOfTracks: album.totalTracks,
                        artistsName: album.artists.compactMap({$0.name}).joined(separator: ", "))
                }
                print("done features")
            case .failure(let error):
                self?.error = error
            }
            group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
            var tempSections = [BrowseSection]()
            tempSections.append(BrowseSection(
                title: "New Releases",
                items: featuredPlaylists))
            self?.sections.value = tempSections
        }
    }
}
