//
//  APICaller.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 10.03.2022.
//

import Foundation
import Alamofire

class APICaller {
    static let shared = APICaller()

    private let baseURL = "https://api.spotify.com/v1"

    
    private init() {}
    
    func getCurrentUserProfile(complition: @escaping (Result<UserProfile, AFError>) -> Void) {
        createRequest(
            url: baseURL + "/me",
            method: .get) { dataRequest in
                dataRequest.responseDecodable(of: UserProfile.self) { response in
                    complition(response.result)
                }
            }
    }
    
    private func createRequest(url: String, method: HTTPMethod ,parameters: [String: String] = [:], completion: @escaping (DataRequest) -> Void) {
        AuthManager.shared.withValidToken { accessToken in
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(accessToken)",
                "Content-Type": "application/json"
            ]
            let request = AF.request(url, method: method, parameters: parameters, encoder: .urlEncodedForm, headers: headers)
            completion(request)
        }
    }
}
