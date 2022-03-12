//
//  RecommendationsResponse.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 12.03.2022.
//

import Foundation

// MARK: - RecommendationsResponse
struct RecommendationsResponse: Codable {
    let tracks: [Track]
    let seeds: [Seed]
}

// MARK: - Seed
struct Seed: Codable {
    let initialPoolSize, afterFilteringSize, afterRelinkingSize: Int
    let id, type: String
    let href: String?
}
