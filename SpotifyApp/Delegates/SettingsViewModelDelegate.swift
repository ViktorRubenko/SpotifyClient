//
//  SettingsViewModelDelegate.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 10.03.2022.
//

import Foundation

protocol SettingsViewModelDelegate: AnyObject {
    func openUserProfile()
    func signOutTapped()
    func signOut()
}
