//
//  Artist.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 12.03.2022.
//

import Foundation


struct Artist: Codable {
    let externalUrls: ExternalUrls
    let followers: Followers?
    let genres: [String]?
    let href: String
    let id: String
    let images: [SpotifyImage]?
    let name: String
    let popularity: Int?
    let type: String
    let uri: String

    enum CodingKeys: String, CodingKey {
        case externalUrls = "external_urls"
        case followers, genres, href, id, images, name, popularity, type, uri
    }
}

// MARK: - ExternalUrls
struct ExternalUrls: Codable {
    let spotify: String
}
