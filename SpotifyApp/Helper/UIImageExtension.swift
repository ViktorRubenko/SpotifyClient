//
//  UIImageExtension.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 14.03.2022.
//

import UIKit

extension UIImage {
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVectors = [
            CIVector(
                x: inputImage.extent.origin.x,
                y: inputImage.extent.origin.y,
                z: inputImage.extent.size.width,
                w: inputImage.extent.origin.y + 3),
            CIVector(
                x: inputImage.extent.origin.x,
                y: inputImage.extent.origin.y,
                z: inputImage.extent.origin.x + 3,
                w: inputImage.extent.size.height),
            CIVector(
                x: inputImage.extent.size.width - 3,
                y: inputImage.extent.origin.y,
                z: inputImage.extent.size.width,
                w: inputImage.extent.size.height),
            CIVector(
                x: inputImage.extent.origin.x,
                y: inputImage.extent.size.height - 3,
                z: inputImage.extent.size.width,
                w: inputImage.extent.size.height),
        ]
        
        var red = 0
        var green = 0
        var blue = 0
        
        for extentVector in extentVectors {
            guard let filter = CIFilter(
                name: "CIAreaAverage",
                parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]
            ) else { return nil }
            guard let outputImage = filter.outputImage else { return nil }
            
            var bitmap = [UInt8](repeating: 0, count: 4)
            let context = CIContext(options: [.workingColorSpace: kCFNull as Any])
            context.render(
                outputImage,
                toBitmap: &bitmap,
                rowBytes: 4,
                bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
                format: .RGBA8,
                colorSpace: nil)
            
            red += Int(bitmap[0])
            green += Int(bitmap[1])
            blue += Int(bitmap[2])
        }
        
        return UIColor(
            red: Double(red) / Double(extentVectors.count) / 255.0,
            green: Double(green) / Double(extentVectors.count) / 255.0,
            blue: Double(blue) / Double(extentVectors.count) / 255.0,
            alpha: 1.0)
    }
}
