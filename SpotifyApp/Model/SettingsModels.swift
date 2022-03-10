//
//  SettingsModels.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 10.03.2022.
//

import Foundation

struct Section {
    let title: String
    let options: [Option]
}

struct Option {
    let title: String
    let handler: () -> Void
}
