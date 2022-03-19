//
//  GradientBackgroundView.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 19.03.2022.
//

import UIKit

class GradientBackgroundView: UIView {
    
    private var startColor: UIColor?
    private var gradientLayer: CAGradientLayer?

    public func setStartColor(_ startColor: UIColor?) {
        self.startColor = startColor
        addGradient()
    }
    
    private func addGradient() {
        guard let startColor = startColor else { return }
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [startColor.cgColor, UIColor.clear.cgColor]
        gradientLayer.shouldRasterize = true
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.7)
        layer.addSublayer(gradientLayer)
        self.gradientLayer = gradientLayer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let gradientLayer = gradientLayer {
            gradientLayer.removeFromSuperlayer()
        }
        addGradient()
    }
}
