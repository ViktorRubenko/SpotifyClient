//
//  ColorPicker.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 17.03.2022.
//

import Foundation
import UIKit

enum ColorPicker {
    private static let colors = [
        UIColor(red: 218/255, green: 20/255, blue: 138/255, alpha: 1),
        UIColor(red: 272/255, green: 40/255, blue: 67/255, alpha: 1),
        UIColor(red: 22/255, green: 136/255, blue: 8/255, alpha: 1),
        UIColor(red: 30/255, green: 50/255, blue: 100/255, alpha: 1),
        UIColor(red: 224/255, green: 51/255, blue: 0, alpha: 1),
        UIColor(red: 224/255, green: 17/255, blue: 138/255, alpha: 1),
        UIColor(red: 212/255, green: 95/255, blue: 92/255, alpha: 1),
        UIColor(red: 138/255, green: 25/255, blue: 50/255, alpha: 1),
        UIColor(red: 71/255, green: 125/255, blue: 148/255, alpha: 1),
        UIColor(red: 229/255, green: 30/255, blue: 49/255, alpha: 1),
        UIColor(red: 119/255, green: 119/255, blue: 119/255, alpha: 1),
        UIColor(red: 165/255, green: 130/255, blue: 82/255, alpha: 1),
        UIColor(red: 185/255, green: 93/255, blue: 6/255, alpha: 1),
        UIColor(red: 176/255, green: 40/255, blue: 151/255, alpha: 1),
        UIColor(red: 237/255, green: 150/255, blue: 35/255, alpha: 1),
        UIColor(red: 79/255, green: 55/255, blue: 79/255, alpha: 1),
        UIColor(red: 225/255, green: 51/255, blue: 0, alpha: 1)
    ]
    
    static func getColor() -> UIColor {
        ColorPicker.colors.randomElement()!
    }
}
