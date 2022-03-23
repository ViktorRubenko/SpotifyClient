//
//  PlayerManager.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 22.03.2022.
//

import Foundation
import AVFoundation

final class PlayerManager {
    
    static let shared = PlayerManager()
    
    private let player = AVPlayer()
    let currentTrackID = Observable<String?>(nil)
    let progression = Observable<Double>(0.0)
    var didFinishCompletion: (() -> Void)?
    var timings = Observable<(duration: Int, currentTime: Int)>((1, 1))
    private var playEndObserver: Any?
    private var statusObserver: NSKeyValueObservation?
    
    private init() {
        player.addPeriodicTimeObserver(
            forInterval: CMTime(value: 1, timescale: 1),
            queue: .main) { time in
                if let duration = self.player.currentItem?.duration, !duration.isIndefinite {
                    self.timings.value = (Int(CMTimeGetSeconds(duration)), Int(CMTimeGetSeconds(time)))
                    self.progression.value = CMTimeGetSeconds(time) / CMTimeGetSeconds(duration)
                }
            }
        
        playEndObserver = NotificationCenter.default.addObserver(
            self,
            selector: #selector(didFinishPlaying),
            name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
            object: player.currentItem)
        
//        statusObserver = player.observe(\.currentItem?.loadedTimeRanges, options: [.new, .old], changeHandler: { player, change in
//            if self.player == player, let timeRanges = change.newValue, let timeRange = timeRanges?.first {
//                let bufferDuration = CMTimeGetSeconds(CMTimeAdd(timeRange.timeRangeValue.start, timeRange.timeRangeValue.duration))
//                guard let duration = player.currentItem?.asset.duration else { return }
//                let seconds = CMTimeGetSeconds(duration)
//
//                if bufferDuration > 2 || bufferDuration == seconds {
//                    self.audioLenght.value = duration
//                }
//            }
//        })
    }
    
    deinit {
        statusObserver?.invalidate()
        if let playEndObserver = playEndObserver {
            NotificationCenter.default.removeObserver(playEndObserver)
        }
    }
    
    func playNewTrack(item: AVPlayerItem) {
        player.replaceCurrentItem(with: item)
        player.play()
    }
    
    func play() {
        player.play()
    }
    
    func pause() {
        player.pause()
    }
    
    func stop() {
        player.pause()
    }
    
    func seekTime(_ seekTime: CMTime) {
        player.seek(to: seekTime)
    }
    
    @objc func didFinishPlaying(_ notification: NSNotification) {
        didFinishCompletion?()
    }
    
}
