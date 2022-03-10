//
//  UserProfile.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 10.03.2022.
//

import Foundation

struct UserProfile: Codable {
    let country: String
    let displayName: String?
    let email: String
    let id: String
    let images: [UserProfileImage]
    let product: String
    let externalURLS: [String: String]
    let explicitContent: [String: Bool]
    let followers:
    
    enum CodingKeys: String, CodingKey {
        case country, email, id, images, product
        case displayName = "display_name"
        case extarnalURLS = "external_urls"
        case explicitContent = "explicit_content"
    }
}

struct UserProfileImage: Codable {
    let url: String
    let height: Int?
    let width: Int?
}

struct Followers: Codable {
    let href: String
    let total: Int
}
