//
//  SearchResponse.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 13.03.2022.
//

import Foundation

struct SearchResponse: Codable {
    let albums: Albums?
    let artists: Artists?
    let tracks: Tracks?
    let playlists: Playlists?
}

struct Artists: Codable {
    let items: [ArtistResponse]
}
