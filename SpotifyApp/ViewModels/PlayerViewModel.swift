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
import MediaPlayer

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
    var shareInfo: String {
        currentTrackResponse.externalUrls.spotify
    }
    private var timings: (duration: Int, currentTime: Int) = (0, 0) {
        didSet {
            updateInfoCenter()
        }
    }
    private var nextURL: String?
    
    let playerState = Observable<PlayerState>(.stopped)
    let trackTitle = Observable<String>("")
    let trackArtist = Observable<String>("")
    let trackImage = Observable<UIImage?>(nil)
    let averageColor = Observable<UIColor?>(nil)
    let playerProgress = Observable<Float>(0.0)
    let error = Observable<ErrorMessageModel?>(nil)
    let trackLenght = Observable<String>("")
    let currentTime = Observable<String>("")
    
    init(trackIndex: Int, trackResponses: [TrackResponse], nextURL: String? = nil) {
        super.init()
        update(trackIndex: trackIndex, trackResponses: trackResponses, nextURL: nextURL)
        
        PlayerManager.shared.didFinishCompletion = { [weak self] in
            self?.playNext()
        }
        progressionObserverUUID = PlayerManager.shared.progression.bind { [weak self] value in
            self?.playerProgress.value = Float(value)
        }
        PlayerManager.shared.timings.bind { [weak self] duration, currentTime in
            self?.timings = (duration, currentTime)
            
            let timeLeft = duration - currentTime
            let tfMinutes = timeLeft % 3600 / 60
            let tfSeconds = timeLeft % 3600 % 60
            self?.trackLenght.value = String(format: "-%02d:%02d", tfMinutes, tfSeconds)
            
            let cMinutes = currentTime % 3600 / 60
            let cSeconds = currentTime % 3600 % 60
            self?.currentTime.value = String(format: "%02d:%02d", cMinutes, cSeconds)
        }
        
        setupAVAudioSession()
    }
    
    deinit {
        PlayerManager.shared.didFinishCompletion = nil
    }
}
// MARK: - Methods
extension PlayerViewModel {
    func fetch() {
        fetchImage()
        trackTitle.value = currentTrackResponse.name
        trackArtist.value = currentTrackResponse.artists.compactMap({$0.name}).joined(separator: ", ")
        
    }
    
    func update(trackIndex: Int, trackResponses: [TrackResponse], nextURL: String? = nil) {
        
        self.trackResponses = trackResponses
        self.currentIndex = trackIndex
        self.nextURL = nextURL
        
        setPlayerItem()
        fetch()
    }
    
    private func fetchImage() {
        SDWebImageManager.shared.loadImage(
            with: findClosestSizeImage(images: currentTrackResponse.album?.images, height: 500, width: 500),
            options: [.highPriority],
            progress: nil) { [weak self] image, _, _, _, _, _ in
                self?.trackImage.value = image
                self?.averageColor.value = image?.averageColor
        }
    }
    
    func fetchNext() {
        guard let nextURL = nextURL else { return }
        APICaller.shared.getNextTracks(url: nextURL) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(AlbumTracks.self, from: data)
                    for trackResponse in response.items {
                        var item = trackResponse
                        item.album = self?.trackResponses.first?.album
                        self?.trackResponses.append(item)
                    }
                    self?.nextURL = response.next
                } catch {}
                
                do {
                    let response = try JSONDecoder().decode(PlaylistDetailTracks.self, from: data)
                    self?.trackResponses += response.items.compactMap { $0.track }
                    self?.nextURL = response.next
                } catch {}
                
                do {
                    let response = try JSONDecoder().decode(UsersSavedTracksResponse.self, from: data)
                    self?.trackResponses += response.items.compactMap { $0.track }
                    self?.nextURL = response.next
                } catch {}
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func createTrackActionsViewModel() -> TrackActionsViewModel {
        TrackActionsViewModel(trackResponse: currentTrackResponse)
    }
}
// MARK: - PlayerItem Logic
extension PlayerViewModel {
    private func setPlayerItem() {
        guard let previewUrl = currentTrackResponse.previewUrl, let url = URL(string: previewUrl) else {
            error.value = ErrorMessageModel(title: "Woops...", message: "Preview is not available for this track.")
            return
        }
        PlayerManager.shared.currentTrackID.value = currentTrackResponse.id
        PlayerManager.shared.playNewTrack(item: AVPlayerItem(url: url))
        print(currentIndex, trackResponses.count / 2)
        if currentIndex > trackResponses.count / 2 {
            fetchNext()
        }
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
}
// MARK: - Player Controls
extension PlayerViewModel {
    
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
        }
        setPlayerItem()
        startPlaying()
    }
    
    func playPrevious() {
        print("play previous")
        PlayerManager.shared.pause()
        if let previousIndex = findPreviousTrack() {
            currentIndex = previousIndex
            fetch()
        }
        setPlayerItem()
        startPlaying()
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
// MARK: - MPCommandCenter
extension PlayerViewModel {
    private func setupAVAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            setupCommandCenter()
        } catch {
            print("Erorr: \(error)")
        }
    }
    
    private func updateInfoCenter() {
        let artwork = MPMediaItemArtwork(boundsSize: CGSize(width: 200, height: 200)) { [weak self] _ in
            self?.trackImage.value ?? UIImage(systemName: "music.note")!
        }
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
            MPMediaItemPropertyArtist: trackArtist.value,
            MPMediaItemPropertyTitle: trackTitle.value,
            MPMediaItemPropertyArtwork: artwork,
            MPMediaItemPropertyPlaybackDuration: timings.duration,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: timings.currentTime
        ]
    }
    
    private func setupCommandCenter() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.isEnabled = true
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.nextTrackCommand.isEnabled = true
        commandCenter.previousTrackCommand.isEnabled = true
        commandCenter.changePlaybackPositionCommand.isEnabled = true
        commandCenter.playCommand.addTarget { [weak self] _ in
            self?.startPlaying()
            return .success
        }
        commandCenter.pauseCommand.addTarget { [weak self] _ in
            self?.pausePlaying()
            return .success
        }
        commandCenter.nextTrackCommand.addTarget { [weak self] _ in
            self?.playNext()
            return .success
        }
        commandCenter.previousTrackCommand.addTarget { [weak self] _ in
            self?.playPrevious()
            return .success
        }
        commandCenter.changePlaybackPositionCommand.addTarget { removeEvent in
            if let event = removeEvent as? MPChangePlaybackPositionCommandEvent {
                let time = CMTime(seconds: event.positionTime, preferredTimescale: 1)
                PlayerManager.shared.seekTime(time)
                return .success
            }
            return .commandFailed
        }
    }
}
