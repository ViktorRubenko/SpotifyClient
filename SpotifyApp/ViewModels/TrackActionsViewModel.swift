//
//  TrackActionsViewModel.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 14.03.2022.
//

import Foundation

enum TrackActionFromType {
    case album, artist, unknown
}

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
    private let from: TrackActionFromType
    
    init(trackResponse: TrackResponse, from: TrackActionFromType = .unknown) {
        self.trackResponse = trackResponse
        self.albumImageURL = findClosestSizeImage(images: trackResponse.album?.images, height: 200, width: 200)
        self.topText = trackResponse.name
        self.bottomText = trackResponse.artists.compactMap({$0.name}).joined(separator: ", ")
        self.from = from
    }
    
    func getActions() {
        var trackActions = [TrackAction]()
        trackActions.append(contentsOf: [
            TrackAction(name: "Add to Favorites", callback: { self.delegate?.addToFavorites() }),
            TrackAction(name: "Share", callback: {
                self.delegate?.share(externalURL: self.trackResponse.externalUrls.spotify)
            })
        ])
        if from == .artist || from == .unknown {
            trackActions.append(TrackAction(name: "Album", callback: {
                self.delegate?.openAlbum(
                    viewModel: AlbumViewModel(itemID: self.trackResponse.album!.id))
            }))
        }
        if from == .album || from == .unknown {
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
