//
//  Album.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 12.03.2022.
//

import Foundation

// MARK: - Album
struct AlbumResponse: Codable {
    let id: String
    let artists: [ArtistResponse]
    let externalUrls: ExternalUrls
    let images: [SpotifyImage]
    let name, releaseDate: String
    let totalTracks: Int
    let type: String?
    let albumGroup: String?
    let copyrights: [Copyrights]?
    let popularity: Int?
    let tracks: AlbumTracks?

    enum CodingKeys: String, CodingKey {
        case id, artists
        case externalUrls = "external_urls"
        case images, name
        case releaseDate = "release_date"
        case totalTracks = "total_tracks"
        case type
        case albumGroup = "album_group"
        case copyrights, popularity, tracks
    }
}

struct AlbumTracks: Codable {
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
