//
//  FeaturedPlaylists.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 12.03.2022.
//

import Foundation

struct FeaturedPlaylists: Codable {
    let playlists: [PlaylistResponse]
    let message: String
}

struct PlaylistResponse: Codable {
    let items: [Playlist]
}
