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
    let artistsName: String
}

struct FeaturesPlaylistCellModel: CellModel {
    let name: String
    let imageURL: URL?
}

struct RecommendationTrackCellModel: CellModel {
    let name: String
    let type: String
    let albumImageURL: URL?
    let artistsName: String
}
