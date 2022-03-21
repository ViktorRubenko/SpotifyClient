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
    case playing, paused
}

final class PlayerViewModel {
    
    private var player = AVPlayer()
    private var trackResponses: [TrackResponse] = []
    private var currentIndex: Int = -1
    private var currentTrackResponse: TrackResponse {
        trackResponses[currentIndex]
    }
    
    let playerState = Observable<PlayerState>(.playing)
    let trackTitle = Observable<String>("")
    let trackArtist = Observable<String>("")
    let trackImage = Observable<UIImage?>(nil)
    let playerProgress = Observable<Float>(0.0)
    
    init(trackIndex: Int, trackResponses: [TrackResponse]) {
        update(trackIndex: trackIndex, trackResponses: trackResponses)
        
        player.addPeriodicTimeObserver(
            forInterval: CMTime(value: 1, timescale: 1),
            queue: .main) { time in
                if let duration = self.player.currentItem?.duration {
                    let duration = CMTimeGetSeconds(duration), time = CMTimeGetSeconds(time)
                    self.playerProgress.value = Float(time / duration)
                }
            }
    }

    func update(trackIndex: Int, trackResponses: [TrackResponse]) {
        self.trackResponses = trackResponses
        self.currentIndex = trackIndex
        
        setPlayerItem()
        fetch()
    }
    
    private func setPlayerItem() {
        player.replaceCurrentItem(with: AVPlayerItem(url: URL(string: currentTrackResponse.previewUrl!)!))
        playerProgress.value = 0.0
    }
    
    func fetch() {
        trackTitle.value = currentTrackResponse.name
        trackArtist.value = currentTrackResponse.artists.compactMap({$0.name}).joined(separator: ", ")
    }
    
    func startPlaying() {
        print("start")
        playerState.value = .playing
        player.play()
    }
    
    func pausePlaying() {
        print("pause")
        playerState.value = .paused
        player.pause()
    }
    
    func playNext() {
        print("play next")
        player.pause()
        if currentIndex < trackResponses.count - 1 {
            currentIndex += 1
            setPlayerItem()
            player.play()
        }
    }
    
    func playPrevious() {
        print("play previous")
        player.pause()
    }
}
