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

protocol TrackActionsViewModelDelegate: AnyObject {
    func addToFavorites()
    func share(externalURL: String)
    func openAlbum(viewModel: AlbumViewModel)
    func showArtist()
    func openArtist(id: String)
}

class TrackActionsViewModel {
    private let trackResponse: TrackResponse
    weak var delegate: TrackActionsViewModelDelegate?
    var trackActions = Observable<[TrackAction]>([])
    let albumImageURL: URL?
    let topText: String
    let bottomText: String
    private let fromArtist: Bool
    
    init(trackResponse: TrackResponse, albumImages: [SpotifyImage]?, fromArtist: Bool = false) {
        self.trackResponse = trackResponse
        self.albumImageURL = findClosestSizeImage(images: albumImages, height: 200, width: 200)
        self.topText = trackResponse.name
        self.bottomText = trackResponse.artists.compactMap({$0.name}).joined(separator: ", ")
        self.fromArtist = fromArtist
    }
    
    func getActions() {
        var trackActions = [TrackAction]()
        trackActions.append(contentsOf: [
            TrackAction(name: "Add to Favorites", callback: { self.delegate?.addToFavorites() }),
            TrackAction(name: "Share", callback: {
                self.delegate?.share(externalURL: self.trackResponse.externalUrls.spotify)
            }),
        ])
        if trackResponse.album != nil {
            trackActions.append(TrackAction(name: "Album", callback: {
                self.delegate?.openAlbum(viewModel: AlbumViewModel(id: self.trackResponse.album!.id))
            }))
        }
        if !fromArtist {
            trackActions.append(TrackAction(name: "Artist", callback: { self.delegate?.showArtist() }))
        }
        self.trackActions.value = trackActions
    }
    
    func getArtistActions() {
        if trackResponse.artists.count > 1 {
            var trackActions = [TrackAction]()
            for artist in trackResponse.artists {
                trackActions.append(TrackAction(
                    name: artist.name,
                    callback: { self.delegate?.openArtist(id: artist.id) }))
            }
            self.trackActions.value = trackActions
        } else {
            delegate?.openArtist(id: trackResponse.artists[0].id)
        }
    }
}

