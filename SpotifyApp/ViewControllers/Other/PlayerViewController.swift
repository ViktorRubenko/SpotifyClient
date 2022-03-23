//
//  PlayerViewController.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 21.03.2022.
//

import UIKit

class PlayerViewController: UIViewController {
    
    var viewModel: PlayerViewModel!
    private lazy var playPopItemButton = UIBarButtonItem(
        image: UIImage(systemName: "play.fill"),
        style: .plain,
        target: self,
        action: #selector(didTapPlayButton))
    private lazy var pausePopItemButton = UIBarButtonItem(
        image: UIImage(systemName: "pause.fill"),
        style: .plain,
        target: self,
        action: #selector(didTapPauseButton))
    private var swipeGestureRecognizerRight: UISwipeGestureRecognizer!
    private var swipeGestureRecognizerLeft: UISwipeGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPopItem()
        setupBinders()
        setupGestureRecognizers()
        
        viewModel.fetch()
    }
}
// MARK: - Methods
extension PlayerViewController {
    func setupGestureRecognizers() {
        
        swipeGestureRecognizerRight = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe))
        swipeGestureRecognizerRight.direction = .right
        popupPresentationContainer?.popupBar.addGestureRecognizer(swipeGestureRecognizerRight)
        
        swipeGestureRecognizerLeft = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe))
        swipeGestureRecognizerLeft.direction = .left
        popupPresentationContainer?.popupBar.addGestureRecognizer(swipeGestureRecognizerLeft)
        
        popupPresentationContainer?.popupInteractionStyle = .none
    }
    
    private func setupPopItem() {
        popupItem.title = ""
        popupItem.subtitle = ""
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
        
        viewModel.error.bind { [weak self] errorMessageModel in
            guard let errorMessageModel = errorMessageModel else { return }
            let alert = UIAlertController(title: errorMessageModel.title, message: errorMessageModel.message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self?.present(alert, animated: true, completion: nil)
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
    
    @objc private func didSwipe(_ swipeGestureRecognizer: UISwipeGestureRecognizer) {
        switch swipeGestureRecognizer.direction {
        case .left:
            print("left")
            viewModel.playNext()
        case .right:
            print("right")
            viewModel.playPrevious()
        default:
            break
        }
    }
}
