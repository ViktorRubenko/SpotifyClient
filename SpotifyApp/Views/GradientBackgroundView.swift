//
//  GradientBackgroundView.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 19.03.2022.
//

import UIKit

class GradientBackgroundView: UIView {
    
    enum GradientStyle {
        case light, medium, hard
    }
    
    private var startColor: UIColor?
    private var gradientLayer: CAGradientLayer?
    var reverse = false
    var style: GradientStyle = .hard

    public func setStartColor(_ startColor: UIColor?) {
        self.startColor = startColor
        addGradient()
    }
    
    private func addGradient() {
        guard let startColor = startColor else { return }
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = !reverse ? [startColor.cgColor, UIColor.clear.cgColor] : [UIColor.clear.cgColor, startColor.cgColor]
        gradientLayer.shouldRasterize = true
        switch style {
        case .light:
            gradientLayer.endPoint = !reverse ? CGPoint(x: 0.5, y: 0.25) : CGPoint(x: 0.5, y: 0.7)
        case .medium:
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.5)
        case .hard:
            gradientLayer.endPoint = !reverse ? CGPoint(x: 0.5, y: 0.7) : CGPoint(x: 0.5, y: 0.25)
        }
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
