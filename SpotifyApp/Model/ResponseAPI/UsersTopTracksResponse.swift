//
//  UsersTopTracksResponse.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 12.03.2022.
//

import Foundation

// MARK: - UsersTopTracksResponse
struct UsersTopTracksResponse: Codable {
    let items: [TrackResponse]
    let total, limit, offset: Int
    let previous: String?
    let href: String
    let next: String?
}
