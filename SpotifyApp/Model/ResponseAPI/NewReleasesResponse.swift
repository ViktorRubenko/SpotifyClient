//
//  NewReleasesResponse.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 12.03.2022.
//

import Foundation

// MARK: - Welcome
struct NewReleasesResponse: Codable {
    let albums: Albums
}

// MARK: - Albums
struct Albums: Codable {
    let href: String
    let items: [Album]
    let limit: Int
    let next: String?
    let offset: Int
    let previous: String?
    let total: Int
}
