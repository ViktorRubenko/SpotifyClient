//
//  Track.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 12.03.2022.
//

import Foundation

// MARK: - Track
struct TrackResponse: Codable {
    var album: AlbumResponse?
    let artists: [ArtistResponse]
    let durationMS: Int
    let externalUrls: ExternalUrls
    let id: String
    let name: String
    let type: String
    let previewUrl: String?

    enum CodingKeys: String, CodingKey {
        case album, artists
        case durationMS = "duration_ms"
        case externalUrls = "external_urls"
        case id
        case name
        case type
        case previewUrl = "preview_url"
    }
}
