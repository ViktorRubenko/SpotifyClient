//
//  UserProfileViewModel.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 10.03.2022.
//

import Foundation
import Alamofire


final class UserProfileViewModel {
    var userImageURL = Observable<String?>(nil)
    var userName = Observable<String?>(nil)
    var userEmail = Observable<String?>(nil)
    
    init() {}
    
    func fetch() {
        APICaller.shared.getCurrentUserProfile { [weak self] result in
            switch result {
            case .success(let userProfile):
                self?.userName.value = userProfile.displayName
                self?.userEmail.value = userProfile.email
                self?.userImageURL.value = userProfile.images.first!.url
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
