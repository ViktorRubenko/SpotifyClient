//
//  ArtistDetailResponse.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 13.03.2022.
//

import Foundation

// MARK: - ArtistDetailResponse
struct ArtistDetailResponse: Codable {
    let externalUrls: ExternalUrls
    let followers: Followers
    let genres: [String]
    let id: String
    let images: [SpotifyImage]
    let name: String
    let popularity: Int

    enum CodingKeys: String, CodingKey {
        case externalUrls = "external_urls"
        case followers, genres, id, images, name, popularity
    }
}
