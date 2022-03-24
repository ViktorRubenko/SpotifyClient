//
//  PlayerViewControllerCoordinator.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 21.03.2022.
//

import Foundation
import UIKit

final class PlayerViewControllerCoordinator: CoordinatorProtocol {
    
    private var containerViewController: UIViewController
    private var averageColor: UIColor?
    private var trackResponses: [TrackResponse]
    private var trackIndex: Int
    private var nextURL: String?
    
    init(
        trackIndex: Int,
        trackResponses: [TrackResponse],
        container: UIViewController,
        nextURL: String? = nil,
        averageColor: UIColor? = nil) {
            self.containerViewController = container
            self.averageColor = averageColor
            self.trackResponses = trackResponses
            self.trackIndex = trackIndex
            self.nextURL = nextURL
    }
    
    func start() {
        
        if trackResponses[trackIndex].previewUrl == nil {
            let alert = UIAlertController(
                title: "Woops...",
                message: "Preview is not available for this track",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            containerViewController.present(alert, animated: true, completion: nil)
            return
        }
    
        if let playerVC = containerViewController.popupContent as? PlayerViewController {
            playerVC.viewModel.update(trackIndex: trackIndex, trackResponses: trackResponses, nextURL: nextURL)
            playerVC.viewModel.startPlaying()
        } else {
            let playerVC = PlayerViewController()
            playerVC.viewModel = PlayerViewModel(trackIndex: trackIndex, trackResponses: trackResponses, nextURL: nextURL)
            containerViewController.presentPopupBar(withContentViewController: playerVC, animated: true, completion: nil)
            playerVC.viewModel.startPlaying()
        }
    }
}
