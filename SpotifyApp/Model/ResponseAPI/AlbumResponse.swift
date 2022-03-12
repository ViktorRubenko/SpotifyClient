//
//  Album.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 12.03.2022.
//

import Foundation


// MARK: - Album
struct AlbumResponse: Codable {
    let albumType: String
    let artists: [ArtistResponse]
    let externalUrls: ExternalUrls
    let id: String
    let images: [SpotifyImage]
    let name, releaseDate: String
    let releaseDatePrecision: String
    let totalTracks: Int
    let type: String

    enum CodingKeys: String, CodingKey {
        case albumType = "album_type"
        case artists
        case externalUrls = "external_urls"
        case id, images, name
        case releaseDate = "release_date"
        case releaseDatePrecision = "release_date_precision"
        case totalTracks = "total_tracks"
        case type
    }
}
