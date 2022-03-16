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
}

protocol ImageInfoModel {
    var name: String { get }
    var imageURL: URL? { get }
    var info: String? { get }
}

protocol TrackContainerModelProtocol {
    var id: String { get }
    var name: String { get }
    var imageURL: URL? { get }
    var tracks: [TrackModel] { get }
}

struct AlbumModel: CellModel, ImageInfoModel {
    let name: String
    let imageURL: URL?
    let info: String?
    let id: String
}

struct PlaylistModel: CellModel, ImageInfoModel {
    let name: String
    let imageURL: URL?
    let info: String?
    let id: String
}

struct TrackModel: CellModel {
    let name: String
    let type: String
    let albumImageURL: URL?
    let artistsName: String
    let id: String
}

struct ArtistModel: CellModel {
    let name: String
    let id: String
}

struct CategoryCellModel: CellModel {
    let name: String
    let id: String
    let iconURL: URL?
}

struct AlbumDetailModel: TrackContainerModelProtocol {
    let name: String
    let imageURL: URL?
    let year: String
    let albumType: String
    let artistName: String
    let tracks: [TrackModel]
    let date: String
    let artists: [ArtistModel]
    let copyright: String
    let id: String
}

struct PlaylistDetailModel: TrackContainerModelProtocol {
    let name: String
    let imageURL: URL?
    let tracks: [TrackModel]
    let id: String
}

struct TrackContainerHeaderModel {
    let topText: String
    let middleText: String
    let bottomText: String
}
