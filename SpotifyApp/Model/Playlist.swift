//
//  Playlist.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 12.03.2022.
//

import Foundation

struct Playlist: Codable {
    let collaborative: Bool
    let description: String?
    let externalUrls: [String: String]
    let followers: Followers?
    let href: String?
    let id: String?
    let images: [SpotifyImage]?
    let owner: Owner?
    let isPublic: Bool?
    let tracks: Tracks?
    let type: String?
    let uri: String?
    
    enum CodingKeys: String, CodingKey {
        case collaborative, description
        case externalUrls = "external_urls"
        case followers, href, id, images, owner
        case isPublic = "public"
        case tracks, type, uri
    }
}

struct Owner: Codable {
    let followers: Followers
    let href: String
    let id: String
    let displayName: String
    let uri: String
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case followers, href, id, uri, type
        case displayName = "display_name"
    }
}
