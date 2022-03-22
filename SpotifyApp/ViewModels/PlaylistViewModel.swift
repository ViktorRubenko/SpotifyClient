//
//  PlaylistViewModel.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 15.03.2022.
//

import Foundation

final class PlaylistViewModel: TrackContainerViewModelProtocol {
    
    var itemID: String
    
    private(set) var trackResponses: [TrackResponse] = []
    var model: TrackContainerModelProtocol?
    var headerModel: TrackContainerHeaderModel?
    var fetched = Observable<Bool>(false)
    let playingTrackID = Observable<String?>(nil)
    private var binderID: UUID?
    
    init(id: String) {
        self.itemID = id
        playingTrackID.value = PlayerManager.shared.currentTrackID.value
        binderID = PlayerManager.shared.currentTrackID.bind { [weak self] value in
            self?.playingTrackID.value = value
        }
    }
    
    deinit {
        if let uuid = binderID {
            PlayerManager.shared.currentTrackID.removeBind(uuid: uuid)
        }
    }
    
    func createTrackActionsViewModel(index: Int) -> TrackActionsViewModel {
        TrackActionsViewModel(trackResponse: trackResponses[index])
    }
    
    func fetch() {
        APICaller.shared.getPlaylist(id: itemID) { [weak self] result in
            switch result {
            case .success(let response):
                self?.model = PlaylistDetailModel(
                    name: response.name,
                    imageURL: findClosestSizeImage(images: response.images, height: 250, width: 250),
                    tracks: response.tracks.items.filter({$0.track?.previewUrl != nil}).compactMap({
                        ItemModel(
                            id: $0.track!.id,
                            name: $0.track!.name,
                            info: $0.track!.artists.compactMap({$0.name}).joined(separator: ", "),
                            imageURL: findClosestSizeImage(images: $0.track!.album!.images, height: 50, width: 50),
                            itemType: .track)}),
                    id: response.id)
                
                self?.headerModel = TrackContainerHeaderModel(
                    topText: response.welcomeDescription,
                    middleText: response.owner.displayName ?? "Spotify",
                    bottomText: response.followers.total > 0 ? "Followers: \(response.followers.total)" : "")
                self?.trackResponses = response.tracks.items.filter({$0.track?.previewUrl != nil}).compactMap({$0.track})
            case .failure(let error):
                print(error.localizedDescription)
            }
            self?.fetched.value = true
        }
    }
    
}
