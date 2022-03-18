//
//  AritstViewModel.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 18.03.2022.
//

import Foundation

struct ArtistSection {
    let title: String
    let items: [ItemModel]
}

final class ArtistViewModel {
    private let itemID: String
    
    var sections = Observable<[ArtistSection]>([])
    
    init(itemID: String) {
        self.itemID = itemID
    }
    
    func fetch() {
        APICaller.shared.getArtist(id: itemID) { response in
            
        }
    }
}
