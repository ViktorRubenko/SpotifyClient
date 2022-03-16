//
//  CategoryViewModel.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 16.03.2022.
//

import Foundation

final class CategoryPlaylistsViewModel {
    let name: String
    let itemID: String
    let playlists = Observable<[PlaylistModel]>([])
    
    init(name: String, itemID: String) {
        self.name = name
        self.itemID = itemID
    }
    
    func fetch() {
        APICaller.shared.getCategoryPlaylists(id: itemID, limit: 40) { [weak self] response in
            switch response {
            case.success(let playlists):
                self?.playlists.value = playlists.playlists.items.compactMap({
                    PlaylistModel(
                        name: $0.name,
                        imageURL: findClosestSizeImage(images: $0.images, height: 180, width: 180),
                        info: $0.owner?.displayName ?? "",
                        id: $0.id)
                })
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
