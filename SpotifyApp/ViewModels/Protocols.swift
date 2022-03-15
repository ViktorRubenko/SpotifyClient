//
//  TrackContainerViewModel.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 15.03.2022.
//

import Foundation

protocol TrackContainerViewModelProtocol {
    var itemID: String { get }
    var model: TrackContainerModelProtocol? { get }
    var headerModel: TrackContainerHeaderModel? { get }
    var fetched: Observable<Bool> { get }
    
    func fetch()
}
