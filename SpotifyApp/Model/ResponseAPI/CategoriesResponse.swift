//
//  CategoriesResponse.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 16.03.2022.
//

import Foundation

// MARK: - CategoriesResponse
struct CategoriesResponse: Codable {
    let categories: Categories
}

// MARK: - Categories
struct Categories: Codable {
    let items: [CategoryItem]
    let limit: Int
    let next: String?
    let offset: Int
    let previous: String?
    let total: Int
}

// MARK: - Item
struct CategoryItem: Codable {
    let href: String
    let icons: [SpotifyImage]
    let id, name: String
}
