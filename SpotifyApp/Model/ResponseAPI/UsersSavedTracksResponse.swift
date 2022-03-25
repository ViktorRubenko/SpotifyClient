//
//  UsersSavedTracksResponse.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 26.03.2022.
//

import Foundation

// MARK: - UsersSavedTracksResponse
struct UsersSavedTracksResponse: Codable {
    let items: [SavedTracksItem]
    let next: String?
}

// MARK: - Item
struct SavedTracksItem: Codable {
    let addedAt: String
    let track: TrackResponse

    enum CodingKeys: String, CodingKey {
        case addedAt = "added_at"
        case track
    }
}
