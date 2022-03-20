//
//  ReleasesViewModel.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 20.03.2022.
//

import Foundation

struct ReleasesSection {
    let title: String
    let items: [ItemModel]
}

final class ReleasesViewModel {
    let itemID: String
    let sections = Observable<[ReleasesSection]>([])
    
    init(id: String) {
        itemID = id
    }
    
    func fetch() {
        var sections = [ReleasesSection]()
        APICaller.shared.getArtistAlbums(id: itemID, limit: 50, includeGroups: ["Single", "Album"]) { [weak self] response in
            switch response {
            case .success(let albums):
                var namesSet = Set<String>()
                var items = [ItemModel]()
                for release in albums.items {
                    if namesSet.contains(release.name) {
                        continue
                    }
                    namesSet.insert(release.name)
                    items.append(ItemModel(
                        id: release.id,
                        name: release.name,
                        info: release.releaseDate.split(separator: "-")[0] + (release.albumType != nil ? "  • \(release.albumType!.capitalized)" : ""),
                        imageURL: findClosestSizeImage(images: release.images, height: 300, width: 300),
                        itemType: .album))
                }
                sections.append(ReleasesSection(
                    title: "Releases",
                    items: items))
                self?.sections.value = sections
            case .failure(let error):
                print("failed to get ArtistAlbums response with: \(error.localizedDescription)")
            }
        }
    }
}
