//
//  AuthManager.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 10.03.2022.
//

import Foundation
import AuthenticationServices
import Alamofire

final class AuthManager {
    static let shared = AuthManager()
    
    private enum Constants {
        static let cliendID = "ec2b205443ea4747ae0a4fefb0c9302f"
        static let clientSecret = "f0993004c0134df9805fd89a9895674a"
        static let redirectURI = "spotifyclient://auth"
        static let scheme = "spotifyclient"
        static let codeURL = "https://accounts.spotify.com/authorize"
        static let tokenURl = "https://accounts.spotify.com/api/token"
        static let scopes = [
            "user-library-modify",
            "user-library-read",
            "user-read-playback-position",
            "user-top-read",
            "user-read-recently-played",
            "playlist-modify-private",
            "playlist-read-private",
            "playlist-modify-public",
            "user-read-private",
            "user-follow-read",
            "user-read-email"
        ].joined(separator: "%20")
    }
    
    private enum Keys: String {
        case accessToken, refreshToken, expirationDate
    }
    
    private init() {}
    
    private var isRefreshingToken = false
    private var waitingToken = [(String)->Void]()
    
    var isSignIn: Bool {
        return accessToken != nil
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
        return Date().addingTimeInterval(300) >= tokenExpirationDate
    }
    
    private func cacheToken(_ response: AuthResponse) {
        UserDefaults.standard.setValue(response.accessToken, forKey: Keys.accessToken.rawValue)
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(response.expiresIn)), forKey: Keys.expirationDate.rawValue)
        if let refreshToken = response.refreshToken {
            UserDefaults.standard.setValue(refreshToken, forKey: Keys.refreshToken.rawValue)
        }
    }
    
    private var signInURL: URL {
        var components = URLComponents(string: Constants.codeURL)!
        
        components.queryItems = [
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "client_id", value: Constants.cliendID),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "scope", value: Constants.scopes),
        ]
        return components.url!
    }
    
    func openAuthSession(
        presentationContextProvider: ASWebAuthenticationPresentationContextProviding,
        completion: @escaping ((Bool) -> Void)
    ) {
        
        let session = ASWebAuthenticationSession(url: signInURL, callbackURLScheme: Constants.scheme) { [weak self] responseURL, error in
            if error == nil, let responseURL = responseURL {
                let components = URLComponents(string: responseURL.absoluteString)!
                let code = String(components.queryItems!.filter({$0.name == "code" }).first!.value!)
                self?.requestAccessToken(code: code, completion: completion)
            } else {
                completion(false)
            }
        }
        session.prefersEphemeralWebBrowserSession = true
        session.presentationContextProvider = presentationContextProvider
        session.start()
    }
    
    private func requestAccessToken(
        code: String,
        completion: @escaping (Bool) -> Void
    ) {
        let parameters = [
            "code": code,
            "grant_type": "authorization_code",
            "redirect_uri": Constants.redirectURI
        ]
        
        let basicBody64 = "\(Constants.cliendID):\(Constants.clientSecret)".data(using: .utf8)!.base64EncodedString()
        let headers: HTTPHeaders = [
            "Authorization": "Basic \(basicBody64)",
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        AF.request(
            Constants.tokenURl,
            method: .post,
            parameters: parameters,
            encoder: .urlEncodedForm,
            headers: headers).responseDecodable(of: AuthResponse.self) { [weak self] response in
                switch response.result {
                case .success(let authResponse):
                    self?.cacheToken(authResponse)
                    completion(true)
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(false)
                }
            }
    }
    
    private func refreshAccessToken(completion: @escaping (Bool) -> Void) {
        guard shouldRefreshToken else {
            completion(true)
            return
        }
        guard let refreshToken = self.refreshToken else {
            return
        }
        
        isRefreshingToken = true
        
        let parameters = [
            "grant_type": "refresh_token",
            "refresh_token": refreshToken
        ]
        
        let basicBody64 = "\(Constants.cliendID):\(Constants.clientSecret)".data(using: .utf8)!.base64EncodedString()
        let headers: HTTPHeaders = [
            "Authorization": "Basic \(basicBody64)",
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        AF.request(
            Constants.tokenURl,
            method: .post,
            parameters: parameters,
            encoder: .urlEncodedForm,
            headers: headers).responseDecodable(of: AuthResponse.self) { [weak self] response in
                self?.isRefreshingToken = false
                switch response.result {
                case .success(let authResponse):
                    self?.cacheToken(authResponse)
                    completion(true)
                    // give new token for awaiting requests
                    self?.waitingToken.forEach { block in
                        block(authResponse.accessToken)
                    }
                    self?.waitingToken.removeAll()
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(false)
                }
            }
        
    }
    
    func refreshIfNeeded(completion: @escaping (Bool) -> Void) {
        if shouldRefreshToken && !isRefreshingToken  {
            refreshAccessToken(completion: completion)
        }
    }
    
    func withValidToken(completion: @escaping (String) -> Void) {
        guard !isRefreshingToken else {
            waitingToken.append(completion)
            return
        }
        if shouldRefreshToken {
            refreshIfNeeded { [weak self] success in
                if success, let token = self?.accessToken {
                    completion(token)
                }
            }
        } else if let token = accessToken {
            completion(token)
        }
    }
}
