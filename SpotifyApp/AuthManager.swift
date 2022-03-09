//
//  AuthManager.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 10.03.2022.
//

import Foundation
import AuthenticationServices

final class AuthManager {
    static let shared = AuthManager()
    
    private enum Constants {
        static let cliendID = "ec2b205443ea4747ae0a4fefb0c9302f"
        static let clientSecret = "f0993004c0134df9805fd89a9895674a"
        static let redirectURI = "spotifyclient://auth"
        static let scheme = "spotifyclient"
        static let baseAuthURL = "https://accounts.spotify.com/authorize"
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
    
    private var signInURL: URL {
        var components = URLComponents(string: Constants.baseAuthURL)!
        
        components.queryItems = [
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "client_id", value: Constants.cliendID),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "scope", value: "user-read-private"),
        ]
        return components.url!
    }
    
    func openAuthSession(
        presentationContextProvider: ASWebAuthenticationPresentationContextProviding,
        completion: @escaping ((Bool) -> Void)) {
            
            let session = ASWebAuthenticationSession(url: signInURL, callbackURLScheme: Constants.scheme) { responseURL, error in
                if error == nil, let responseURL = responseURL {
                    let components = URLComponents(string: responseURL.absoluteString)!
                    let code = components.queryItems?.filter({$0.name == "code" }).first!.value
                    print(code)
                } else {
                    completion(false)
                }
            }
            session.presentationContextProvider = presentationContextProvider
            session.start()
        }
}
