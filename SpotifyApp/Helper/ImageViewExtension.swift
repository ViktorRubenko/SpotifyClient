//
//  UIImageExtension.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 10.03.2022.
//

import UIKit
import Alamofire

extension UIImageView {
    func imageFromURL(urlString: String) {
        AF.request(urlString, method: .get).response { [weak self] response in
            switch response.result {
            case .success(let data):
                if let data = data {
                    self?.image = UIImage(data: data)
                }
            case .failure(let error):
                print("Failed to load image: \(error.localizedDescription)")
            }
        }
    }
}
