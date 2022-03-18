//
//  ArtistsTopTracksResponse.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 19.03.2022.
//

import Foundation

struct ArtistsTopTracksResponse: Codable {
    let tracks: [TrackResponse]
}
