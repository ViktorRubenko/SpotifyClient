//
//  NewReleasesCellModel.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 12.03.2022.
//

import Foundation

protocol CellModel {}

struct NewReleasesCellModel: CellModel {
    let name: String
    let imageURL: URL?
    let numberOfTracks: Int
    let artistsName: String
}
