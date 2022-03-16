//
//  PlaylistDetailResponse.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 15.03.2022.
//

import Foundation

// MARK: - PlaylistDetailResponse
struct PlaylistDetailResponse: Codable {
    let collaborative: Bool
    let welcomeDescription: String
    let externalUrls: ExternalUrls
    let followers: Followers
    let href: String
    let id: String
    let images: [SpotifyImage]
    let name: String
    let owner: Owner
    let welcomePublic: Bool
    let snapshotID: String
    let tracks: PlaylistDetailTracks
    let type, uri: String
    
    enum CodingKeys: String, CodingKey {
        case collaborative
        case welcomeDescription = "description"
        case externalUrls = "external_urls"
        case followers, href, id, images, name, owner
        case welcomePublic = "public"
        case snapshotID = "snapshot_id"
        case tracks, type, uri
    }
}

// MARK: - Tracks
struct PlaylistDetailTracks: Codable {
    let href: String
    let items: [PlaylistDetailItem]
    let limit: Int
    let next: String?
    let offset: Int
    let previous: String?
    let total: Int
}

// MARK: - Item
struct PlaylistDetailItem: Codable {
    let addedAt: String?
    let addedBy: Owner
    let isLocal: Bool
    let track: TrackResponse?
    
    enum CodingKeys: String, CodingKey {
        case addedAt = "added_at"
        case addedBy = "added_by"
        case isLocal = "is_local"
        case track
    }
}
