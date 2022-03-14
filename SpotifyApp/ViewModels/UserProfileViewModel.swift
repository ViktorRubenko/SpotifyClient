//
//  UserProfileViewModel.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 10.03.2022.
//

import Foundation
import Alamofire


final class UserProfileViewModel {
    var userImageURL = Observable<URL?>(nil)
    var userName = Observable<String?>(nil)
    var contents = Observable<[String]>([])
    var error = Observable<AFError?>(nil)
    
    init() {}
    
    func fetch() {
        APICaller.shared.getCurrentUserProfile { [weak self] result in
            switch result {
            case .success(let userProfile):
                self?.userName.value = userProfile.displayName
                self?.userImageURL.value = URL(string: userProfile.images.first?.url ?? "")
                
                var contents = [String]()
                contents.append("Email Address: \(userProfile.email)")
                contents.append("Plan: \(userProfile.product)")
                contents.append("User ID: \(userProfile.id)")
                
                self?.contents.value = contents
            case .failure(let error):
                self?.error.value = error
                print(error.localizedDescription)
            }
        }
    }
}
