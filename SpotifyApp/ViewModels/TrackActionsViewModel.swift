//
//  TrackActionsViewModel.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 14.03.2022.
//

import Foundation

struct TrackActionsViewModel {
    private let itemID: String
    
    private(set) var actions = ["Favorite", "Hide", "Add", "add", "Share", "radio", "arist", "about"]

    init(itemID: String, fromAlbum: Bool) {
        self.itemID = itemID
    }
    
    func fetch() {
        APICaller.shared.getTrack(id: itemID) { result in
            
        }
    }
}

