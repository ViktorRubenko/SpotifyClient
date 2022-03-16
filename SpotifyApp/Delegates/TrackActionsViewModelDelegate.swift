//
//  TrackActionsViewModelDelegate.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 16.03.2022.
//

import Foundation
import UIKit

protocol TrackActionsViewModelDelegate: AnyObject {
    func addToFavorites()
    func share(externalURL: String)
    func openAlbum(viewModel: AlbumViewModel)
    func showArtist()
}
