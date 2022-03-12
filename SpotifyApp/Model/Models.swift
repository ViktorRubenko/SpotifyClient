//
//  NewReleasesCellModel.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 12.03.2022.
//

import Foundation

protocol CellModel {
    var id: String { get }
    var name: String { get }
}

struct AlbumModel: CellModel {
    let name: String
    let imageURL: URL?
    let artistsName: String
    let id: String
}

struct PlaylistModel: CellModel {
    let name: String
    let imageURL: URL?
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

struct AlbumDetailModel: CellModel {
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
