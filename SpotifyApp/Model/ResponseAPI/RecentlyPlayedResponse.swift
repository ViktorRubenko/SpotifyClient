//
//  RecentlyPlayedResponse.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 13.03.2022.
//

import Foundation

// MARK: - RecentlyPlayedResponse
struct RecentlyPlayedResponse: Codable {
    let items: [Item]
    let limit: Int
}

// MARK: - Item
struct Item: Codable {
    let track: TrackResponse
}
