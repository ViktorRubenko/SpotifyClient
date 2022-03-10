//
//  Album.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 12.03.2022.
//

import Foundation


// MARK: - Album
struct Album: Codable {
    let albumType: String
    let artists: [Artist]
    let availableMarkets: [String]
    let externalUrls: ExternalUrls
    let href: String
    let id: String
    let images: [SpotifyImage]
    let name, releaseDate: String
    let releaseDatePrecision: String
    let totalTracks: Int
    let type: String
    let uri: String

    enum CodingKeys: String, CodingKey {
        case albumType = "album_type"
        case artists
        case availableMarkets = "available_markets"
        case externalUrls = "external_urls"
        case href, id, images, name
        case releaseDate = "release_date"
        case releaseDatePrecision = "release_date_precision"
        case totalTracks = "total_tracks"
        case type, uri
    }
}


