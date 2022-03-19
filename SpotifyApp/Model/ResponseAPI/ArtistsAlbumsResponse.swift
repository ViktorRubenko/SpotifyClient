//
//  ArtistsAlbumsResponse.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 20.03.2022.
//

import Foundation

// MARK: - ArtistsAlbumsResponse
struct ArtistsAlbumsResponse: Codable {
    let href: String
    let items: [AlbumResponse]
    let limit: Int
    let next: String?
    let offset: Int
    let previous: String?
    let total: Int
}
