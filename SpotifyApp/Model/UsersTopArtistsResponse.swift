//
//  UsersTopArtistsResponse.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 12.03.2022.
//

import Foundation

// MARK: - UsersTopArtistsResponse
struct UsersTopArtistsResponse: Codable {
    let items: [Artist]
    let total, limit, offset: Int
    let previous: String?
    let href: String
    let next: String?
}

// MARK: - Followers
struct Followers: Codable {
    let href: String?
    let total: Int
}
