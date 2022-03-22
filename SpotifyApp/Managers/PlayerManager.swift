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
    let progression = Observable<Float>(0.0)
    var didFinishCompletion: (() -> Void)?
    private var observer: Any?
    
    private init() {
        player.addPeriodicTimeObserver(
            forInterval: CMTime(value: 1, timescale: 1),
            queue: .main) { time in
                if let duration = self.player.currentItem?.duration {
                    let duration = CMTimeGetSeconds(duration), time = CMTimeGetSeconds(time)
                    self.progression.value = Float(time / duration)
                }
            }
        
        observer = NotificationCenter.default.addObserver(
            self,
            selector: #selector(didFinishPlaying),
            name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
            object: player.currentItem)
    }
    
    deinit {
        guard let observer = observer else {
            return
        }
        NotificationCenter.default.removeObserver(observer)
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
    
    @objc func didFinishPlaying(_ notification: NSNotification) {
        didFinishCompletion?()
    }
    
}
