//
//  PlayerViewController.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 21.03.2022.
//

import UIKit
import LNPopupController_ObjC

class PlayerViewController: UIViewController {
    
    var viewModel: PlayerViewModel!
    private lazy var playPopItemButton = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(didTapPlayButton))
    private lazy var pausePopItemButton = UIBarButtonItem(barButtonSystemItem: .pause, target: self, action: #selector(didTapPauseButton))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPopItem()
        setupBinders()
        
        viewModel.fetch()
    }
}
// MARK: - Methods
extension PlayerViewController {
    private func setupPopItem() {
        popupItem.title = "Test"
        popupItem.subtitle = "test2"
        popupItem.image = UIImage(systemName: "music.note")
        popupItem.trailingBarButtonItems = [
            playPopItemButton
        ]
        popupItem.progress = 0.0
    }
    
    private func setupBinders() {
        viewModel.playerState.bind { [weak self] playerState in
            switch playerState {
            case .playing:
                self?.popupItem.trailingBarButtonItems = [
                    self!.pausePopItemButton
                ]
            case .paused, .stopped:
                self?.popupItem.trailingBarButtonItems = [
                    self!.playPopItemButton
                ]
            }
        }
        
        viewModel.playerProgress.bind { [weak self] progress in
            self?.popupItem.progress = progress
        }
        
        viewModel.trackArtist.bind { [weak self] artist in
            self?.popupItem.subtitle = artist
        }
        
        viewModel.trackTitle.bind { [weak self] trackTitle in
            self?.popupItem.title = trackTitle
        }
    }
}
// MARK: - Actions
extension PlayerViewController {
    @objc private func didTapPlayButton() {
        viewModel.startPlaying()
    }
    
    @objc private func didTapPauseButton() {
        viewModel.pausePlaying()
    }
}
