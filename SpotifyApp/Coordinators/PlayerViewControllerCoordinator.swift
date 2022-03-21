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
    
    init(trackIndex: Int, trackResponses: [TrackResponse] = [], container: UIViewController, averageColor: UIColor? = nil) {
        self.containerViewController = container
        self.averageColor = averageColor
        self.trackResponses = trackResponses
        self.trackIndex = trackIndex
    }
    
    func start() {
        containerViewController.popupBar.inheritsAppearanceFromDockingView = false
        containerViewController.popupBar.backgroundColor = averageColor
        containerViewController.popupBar.progressViewStyle = .bottom
        
        if let playerVC = containerViewController.popupContent as? PlayerViewController {
            playerVC.viewModel.update(trackIndex: trackIndex, trackResponses: trackResponses)
            playerVC.viewModel.startPlaying()
        } else {
            let playerVC = PlayerViewController()
            playerVC.viewModel = PlayerViewModel(trackIndex: trackIndex, trackResponses: trackResponses)
            containerViewController.presentPopupBar(withContentViewController: playerVC, animated: true, completion: nil)
            playerVC.viewModel.startPlaying()
        }
    }
}
