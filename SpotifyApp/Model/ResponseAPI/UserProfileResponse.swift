//
//  UserProfile.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 10.03.2022.
//

import Foundation

struct UserProfileResponse: Codable {
    let country: String
    let displayName: String?
    let email: String
    let id: String
    let images: [SpotifyImage]
    let product: String
    let externalURLS: [String: String]
    let explicitContent: [String: Bool]
    
    enum CodingKeys: String, CodingKey {
        case country, email, id, images, product
        case displayName = "display_name"
        case externalURLS = "external_urls"
        case explicitContent = "explicit_content"
    }
}
