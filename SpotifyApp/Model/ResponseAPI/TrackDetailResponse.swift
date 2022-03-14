//
//  TrackDetailResponse.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 13.03.2022.
//

import Foundation

struct TrackDetailResponse: Codable {
    let album: AlbumResponse
    let artists: [ArtistResponse]
    let discNumber, durationMS: Int
    let explicit: Bool
    let externalUrls: ExternalUrls
    let id: String
    let isLocal: Bool
    let name: String
    let popularity: Int
    let previewURL: String
    let trackNumber: Int
    let type: String

    enum CodingKeys: String, CodingKey {
        case album, artists
        case discNumber = "disc_number"
        case durationMS = "duration_ms"
        case explicit
        case externalUrls = "external_urls"
        case id
        case isLocal = "is_local"
        case name, popularity
        case previewURL = "preview_url"
        case trackNumber = "track_number"
        case type
    }
}
