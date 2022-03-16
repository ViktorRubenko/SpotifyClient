//
//  TrackActionsViewModel.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 14.03.2022.
//

import Foundation

struct TrackAction {
    let name: String
    let callback: (() -> Void)
}

class TrackActionsViewModel {
    private let trackResponse: TrackResponse
    weak var delegate: TrackActionsViewModelDelegate?
    private(set) var trackActions = [TrackAction]()
    let albumImageURL: URL?
    let topText: String
    let bottomText: String
    
    init(trackResponse: TrackResponse, albumImages: [SpotifyImage]) {
        self.trackResponse = trackResponse
        self.albumImageURL = findClosestSizeImage(images: albumImages, height: 200, width: 200)
        self.topText = trackResponse.name
        self.bottomText = trackResponse.artists.compactMap({$0.name}).joined(separator: ", ")
        fillActions()
    }
    
    private func fillActions() {
        trackActions.append(contentsOf: [
            TrackAction(name: "Add to Favorites", callback: { self.delegate?.addToFavorites() }),
            TrackAction(name: "Share", callback: {
                self.delegate?.share(externalURL: self.trackResponse.externalUrls.spotify)
            }),
        ])
        if trackResponse.album != nil {
            trackActions.append(TrackAction(name: "Album", callback: {
                
            }))
        }
        trackActions.append(TrackAction(name: "Artist", callback: { self.delegate?.showArtist() }))
    }
}

