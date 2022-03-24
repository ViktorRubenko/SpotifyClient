//
//  PlaylistViewModel.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 15.03.2022.
//

import Foundation

final class PlaylistViewModel: PlayingTrackViewModel, TrackContainerViewModelProtocol {
    
    private(set) var itemID: String
    var model: TrackContainerModelProtocol?
    private(set) var tracks = [ItemModel]()
    var headerModel: TrackContainerHeaderModel?
    var fetched = Observable<Bool>(false)
    var fetchedNext = Observable<Bool>(false)
    private(set) var trackResponses = [TrackResponse]()
    private var nextURL: String?
    let nextTracksLimit = 20
    
    init(id: String) {
        self.itemID = id
        super.init()
    }
    
    func fetch() {
        APICaller.shared.getPlaylist(id: itemID, limit: nextTracksLimit) { [weak self] result in
            switch result {
            case .success(let response):
                guard let self = self else { return }
                self.model = PlaylistDetailModel(
                    name: response.name,
                    imageURL: findClosestSizeImage(images: response.images, height: 250, width: 250),
                    id: response.id)
                self.tracks = self.extractTracks(response.tracks)
                self.headerModel = TrackContainerHeaderModel(
                    topText: response.welcomeDescription,
                    middleText: response.owner.displayName ?? "Spotify",
                    bottomText: response.followers.total > 0 ? "Followers: \(response.followers.total)" : "")
                self.nextURL = response.tracks.next
                self.trackResponses = response.tracks.items.compactMap({$0.track})
            case .failure(let error):
                print(error.localizedDescription)
            }
            self?.fetched.value = true
        }
    }
    
    func fetchNext() {
        guard let nextURL = nextURL else {
            return
        }

        APICaller.shared.getNextTracksPlaylist(url: nextURL) { [weak self] result in
            switch result {
            case .success(let tracks):
                guard let self = self else { return }
                self.tracks += self.extractTracks(tracks)
                self.trackResponses += tracks.items.compactMap { $0.track }
                self.fetchedNext.value = true
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func extractTracks(_ response: PlaylistDetailTracks) -> [ItemModel] {
        return response.items.compactMap({
            ItemModel(
                id: $0.track!.id,
                name: $0.track!.name,
                info: $0.track!.artists.compactMap({$0.name}).joined(separator: ", "),
                imageURL: findClosestSizeImage(images: $0.track!.album!.images, height: 50, width: 50),
                itemType: .track)})
    }
    
}
