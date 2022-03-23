//
//  PlayerViewModel.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 21.03.2022.
//

import Foundation
import UIKit
import AVKit

enum PlayerState {
    case playing, paused, stopped
}

final class PlayerViewModel: NSObject {
    
    private var trackResponses: [TrackResponse] = []
    private var currentIndex: Int = -1
    private var currentTrackResponse: TrackResponse {
        trackResponses[currentIndex]
    }
    
    let playerState = Observable<PlayerState>(.stopped)
    let trackTitle = Observable<String>("")
    let trackArtist = Observable<String>("")
    let trackImage = Observable<UIImage?>(nil)
    let playerProgress = Observable<Float>(0.0)
    let error = Observable<ErrorMessageModel?>(nil)
    
    init(trackIndex: Int, trackResponses: [TrackResponse]) {
        super.init()
        update(trackIndex: trackIndex, trackResponses: trackResponses)
        
        PlayerManager.shared.didFinishCompletion = { [weak self] in
            self?.playNext()
        }
        PlayerManager.shared.progression.bind { [weak self] value in
            self?.playerProgress.value = value
        }
    }
    
    deinit {
        PlayerManager.shared.didFinishCompletion = nil
    }
}
// MARK: - Player Methods
extension PlayerViewModel {
    func update(trackIndex: Int, trackResponses: [TrackResponse]) {
        self.trackResponses = trackResponses
        self.currentIndex = trackIndex
        
        setPlayerItem()
        fetch()
    }

    private func setPlayerItem() {
        guard let previewUrl = currentTrackResponse.previewUrl, let url = URL(string: previewUrl) else {
            error.value = ErrorMessageModel(title: "Woops...", message: "Preview is not available for this track.")
            return
        }
        PlayerManager.shared.currentTrackID.value = currentTrackResponse.id
        PlayerManager.shared.playNewTrack(item: AVPlayerItem(url: url))
    }
    
    func fetch() {
        trackTitle.value = currentTrackResponse.name
        trackArtist.value = currentTrackResponse.artists.compactMap({$0.name}).joined(separator: ", ")
    }

    func findNextIndex() -> Int? {
        if currentIndex >= trackResponses.count - 1 {
            return nil
        }
        for (index, trackResponse) in trackResponses[currentIndex + 1..<trackResponses.count].enumerated() {
            if trackResponse.previewUrl != nil {
                return currentIndex + index + 1
            }
        }
        return nil
    }
    
    func findPreviousTrack() -> Int? {
        if currentIndex <= 0 {
            return nil
        }
        for (index, trackResponse) in trackResponses[..<currentIndex].enumerated().reversed() {
            if trackResponse.previewUrl != nil {
                return index
            }
        }
        return nil

    }
    
    func startPlaying() {
        switch playerState.value {
        case .playing:
            break
        case .paused:
            PlayerManager.shared.play()
            playerState.value = .playing
        case .stopped:
            setPlayerItem()
            PlayerManager.shared.play()
            playerState.value = .playing
        }
    }
    
    func pausePlaying() {
        print("pause")
        playerState.value = .paused
        PlayerManager.shared.pause()
    }
    
    func stopPlaying() {
        print("stop")
        playerState.value = .stopped
    }
    
    func playNext() {
        if let nextIndex = findNextIndex() {
            currentIndex = nextIndex
            fetch()
            
            setPlayerItem()
            startPlaying()
        } else {
            stopPlaying()
        }
    }
    
    func playPrevious() {
        print("play previous")
        PlayerManager.shared.pause()
        if let previousIndex = findPreviousTrack() {
            currentIndex = previousIndex
            fetch()
            
            setPlayerItem()
            startPlaying()
        } else {
            stopPlaying()
        }
    }
}
