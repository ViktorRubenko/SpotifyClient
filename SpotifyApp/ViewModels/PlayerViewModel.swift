//
//  PlayerViewModel.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 21.03.2022.
//

import Foundation
import UIKit
import AVKit
import SDWebImage

enum PlayerState {
    case playing, paused, stopped
}

final class PlayerViewModel: NSObject {
    
    private var trackResponses: [TrackResponse] = []
    private var currentIndex: Int = -1
    private var currentTrackResponse: TrackResponse {
        trackResponses[currentIndex]
    }
    private var progressionObserverUUID: UUID?
    
    let playerState = Observable<PlayerState>(.stopped)
    let trackTitle = Observable<String>("")
    let trackArtist = Observable<String>("")
    let trackImage = Observable<UIImage?>(nil)
    let playerProgress = Observable<Float>(0.0)
    let error = Observable<ErrorMessageModel?>(nil)
    let trackLenght = Observable<String>("")
    let currentTime = Observable<String>("")
    
    init(trackIndex: Int, trackResponses: [TrackResponse]) {
        super.init()
        update(trackIndex: trackIndex, trackResponses: trackResponses)
        
        PlayerManager.shared.didFinishCompletion = { [weak self] in
            self?.playNext()
        }
        progressionObserverUUID = PlayerManager.shared.progression.bind { [weak self] value in
            self?.playerProgress.value = Float(value)
        }
        PlayerManager.shared.timings.bind { [weak self] duration, currentTime in
            let timeLeft = duration - currentTime
            let tfMinutes = timeLeft % 3600 / 60
            let tfSeconds = timeLeft % 3600 % 60
            self?.trackLenght.value = String(format: "-%02d:%02d", tfMinutes, tfSeconds)
            
            let cMinutes = currentTime % 3600 / 60
            let cSeconds = currentTime % 3600 % 60
            self?.currentTime.value = String(format: "%02d:%02d", cMinutes, cSeconds)
        }
    }
    
    deinit {
        PlayerManager.shared.didFinishCompletion = nil
    }
}
// MARK: - Player Methods
extension PlayerViewModel {
    func fetch() {
        fetchImage()
        trackTitle.value = currentTrackResponse.name
        trackArtist.value = currentTrackResponse.artists.compactMap({$0.name}).joined(separator: ", ")
    }
    
    func update(trackIndex: Int, trackResponses: [TrackResponse]) {
        
        self.trackResponses = trackResponses
        self.currentIndex = trackIndex
        
        setPlayerItem()
        fetch()
    }
    
    private func fetchImage() {
        SDWebImageManager.shared.loadImage(
            with: findClosestSizeImage(images: currentTrackResponse.album?.images, height: 500, width: 500),
            options: [.highPriority],
            progress: nil) { [weak self] image, _, error, _, _, _ in
                self?.trackImage.value = image
        }
    }

    private func setPlayerItem() {
        guard let previewUrl = currentTrackResponse.previewUrl, let url = URL(string: previewUrl) else {
            error.value = ErrorMessageModel(title: "Woops...", message: "Preview is not available for this track.")
            return
        }
        PlayerManager.shared.currentTrackID.value = currentTrackResponse.id
        PlayerManager.shared.playNewTrack(item: AVPlayerItem(url: url))
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
        PlayerManager.shared.stop()
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
    
    func sliderChanged(_ value: Float) {
        if let progressionObserverUUID = progressionObserverUUID {
            PlayerManager.shared.progression.removeBind(uuid: progressionObserverUUID)
        }
        let duration = PlayerManager.shared.timings.value.duration
        let seekTime = CMTime(value: Int64(Float(duration) * value), timescale: 1)
        PlayerManager.shared.seekTime(seekTime)
    }
    
    func tapSlider() {
        progressionObserverUUID = PlayerManager.shared.progression.bind { [weak self] value in
            self?.playerProgress.value = Float(value)
        }
    }
}
