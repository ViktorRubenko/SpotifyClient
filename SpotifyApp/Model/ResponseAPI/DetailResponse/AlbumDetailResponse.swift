//
//  AlbumDetailResponse.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 13.03.2022.
//

import Foundation

// MARK: - AlbumDetailResponse
struct AlbumDetailResponse: Codable {
    let artists: [DetailArtist]
    let copyrights: [Copyrights]
    let externalUrls: ExternalUrls
    let genres: [String?]
    let id: String
    let images: [SpotifyImage]
    let name: String
    let popularity: Int
    let releaseDate, releaseDatePrecision: String
    let totalTracks: Int
    let tracks: AlbumDetailTracks
    let type: String

    enum CodingKeys: String, CodingKey {
        case artists
        case copyrights
        case externalUrls = "external_urls"
        case genres, id, images, name, popularity
        case releaseDate = "release_date"
        case releaseDatePrecision = "release_date_precision"
        case totalTracks = "total_tracks"
        case tracks, type
    }
}

struct AlbumDetailTracks: Codable {
    let href: String
    let items: [TrackResponse]
    let limit: Int
    let next: String?
    let offset: Int
    let previous: String?
    let total: Int
}

struct Copyrights: Codable {
    let text: String
    let type: String
}

struct DetailArtist: Codable {
    let externalUrls: ExternalUrls
    let id, name, type: String

    enum CodingKeys: String, CodingKey {
        case externalUrls = "external_urls"
        case id, name, type
    }
}
