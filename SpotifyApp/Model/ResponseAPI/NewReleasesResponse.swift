//
//  NewReleasesResponse.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 12.03.2022.
//

import Foundation

// MARK: - Welcome
struct NewReleasesResponse: Codable {
    let albums: Albums
}

// MARK: - Albums
struct Albums: Codable {
    let href: String
    let items: [Item]
    let limit: Int
    let next: String?
    let offset: Int
    let previous: String?
    let total: Int
}

// MARK: - Item
struct Item: Codable {
    let albumType: String
    let artists: [Artist]
    let availableMarkets: [String]
    let externalUrls: ExternalUrls
    let href: String
    let id: String
    let images: [SpotifyImage]
    let name, releaseDate, releaseDatePrecision: String
    let totalTracks: Int
    let type, uri: String

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
