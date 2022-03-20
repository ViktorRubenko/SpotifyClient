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
        APICaller.shared.getArtistAlbums(id: itemID, limit: 50, includeGroups: ["Single", "Album"]) { response in
            switch response {
            case .success(let albums):
                sections.append(ReleasesSection(
                    title: "Releases",
                    items: albums.items.compactMap({
                        ItemModel(
                            id: $0.id,
                            name: $0.name,
                            info: $0.albumType,
                            imageURL: findClosestSizeImage(images: $0.images, height: 150, width: 150),
                            itemType: .album)
                    })))
            case .failure(let error):
                print("failed to get ArtistAlbums response with: \(error.localizedDescription)")
            }
        }
    }
}
