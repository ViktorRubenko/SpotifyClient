//
//  Functions.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 12.03.2022.
//

import Foundation

func findClosestSizeImage(images: [SpotifyImage]?, height: Double, width: Double) -> URL? {
    guard let images = images else {
        return nil
    }
    
    func distance(_ image: SpotifyImage) -> Double {
        let h = Double(image.height ?? 1000)
        let w = Double(image.width ?? 1000)
        
        return sqrt(pow(h - height, 2) + pow(w - width, 2))
    }
    
    guard images.count > 0 else {
        return nil
    }
    if images.count == 1 {
        return URL(string: images[0].url)
    }
    
    var closestImage = images[0]
    var closestValue: Double = .greatestFiniteMagnitude
    
    images.forEach {
        let thisDistance = distance($0)
        if thisDistance < closestValue {
            closestImage = $0
            closestValue = thisDistance
        }
    }
    return URL(string: closestImage.url)
}
