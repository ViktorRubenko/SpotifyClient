//
//  PlayingTrackProtocol.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 22.03.2022.
//

import Foundation

class PlayingTrackViewModel: PlayingViewModelProtocol {
    let playingTrackID = Observable<String?>(nil)
    private(set) var binderID: UUID?
    
    init() {
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
}
