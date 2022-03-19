//
//  Models.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 12.03.2022.
//

import Foundation

protocol CellModel {
    var id: String { get }
    var name: String { get }
    var info: String? { get }
    var imageURL: URL? { get }
}

protocol TrackContainerModelProtocol {
    var id: String { get }
    var name: String { get }
    var imageURL: URL? { get }
    var tracks: [ItemModel] { get }
}

struct AlbumDetailModel: TrackContainerModelProtocol {
    let name: String
    let imageURL: URL?
    let year: String
    let albumType: String
    let artistName: String
    let tracks: [ItemModel]
    let date: String
    let artists: [ItemModel]
    let copyright: String
    let id: String
}

struct PlaylistDetailModel: TrackContainerModelProtocol {
    let name: String
    let imageURL: URL?
    let tracks: [ItemModel]
    let id: String
}

struct TrackContainerHeaderModel {
    let topText: String
    let middleText: String
    let bottomText: String
}

enum ItemType {
    case track, album, playlist, artist, noResults, category, unknown
}

struct ItemModel: CellModel {
    let id: String
    let name: String
    let info : String?
    let imageURL: URL?
    let itemType: ItemType
}
