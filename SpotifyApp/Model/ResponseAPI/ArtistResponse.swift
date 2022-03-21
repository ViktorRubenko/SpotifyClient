//
//  Artist.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 12.03.2022.
//

import Foundation

struct ArtistResponse: Codable {
    let externalUrls: ExternalUrls
    let id: String
    let name: String
    let images: [SpotifyImage]?
    let type: String
    let followers: Followers?
    let popularity: Int?

    enum CodingKeys: String, CodingKey {
        case externalUrls = "external_urls"
        case id, name, images, type
        case followers, popularity
    }
}

// MARK: - ExternalUrls
struct ExternalUrls: Codable {
    let spotify: String
}
