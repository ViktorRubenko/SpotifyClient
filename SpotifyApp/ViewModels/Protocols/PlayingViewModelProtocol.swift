//
//  PlayingViewModelProtocol.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 22.03.2022.
//

import Foundation

protocol PlayingViewModelProtocol {
    var playingTrackID: Observable<String?> { get }
    var binderID: UUID? { get }
}
