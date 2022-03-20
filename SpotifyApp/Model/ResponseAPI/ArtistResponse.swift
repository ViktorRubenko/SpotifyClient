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

    enum CodingKeys: String, CodingKey {
        case externalUrls = "external_urls"
        case id, name, images
    }
}

// MARK: - ExternalUrls
struct ExternalUrls: Codable {
    let spotify: String
}
