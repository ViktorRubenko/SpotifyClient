//
//  AuthManager.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 10.03.2022.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()
    
    private enum Constants {
        static let cliendID = "ec2b205443ea4747ae0a4fefb0c9302f"
    }
    
    private enum Keys: String {
        case accessToken, refreshToken, expirationDate
    }
    
    private init() {}
    
    var isSignIn: Bool {
        accessToken != nil
    }
    
    private var accessToken: String? {
        UserDefaults.standard.string(forKey: Keys.accessToken.rawValue)
    }
    
    private var refreshToken: String? {
        UserDefaults.standard.string(forKey: Keys.refreshToken.rawValue)
    }
    
    private var tokenExpirationDate: Date? {
        UserDefaults.standard.value(forKey: Keys.expirationDate.rawValue) as? Date
    }
    
    private var shouldRefreshToken: Bool {
        guard let tokenExpirationDate = tokenExpirationDate else {
            return false
        }
        return Date() >= tokenExpirationDate
    }
    
    private func cacheToken(_ token: String) {
        UserDefaults.standard.setValue(token, forKey: Keys.accessToken.rawValue)
        UserDefaults.standard.setValue(Date(), forKey: Keys.expirationDate.rawValue)
    }
}
