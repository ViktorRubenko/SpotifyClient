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
    private var endColor: UIColor = .clear
    private var gradientLayer: CAGradientLayer?
    var style: GradientStyle = .hard

    public func setStartColor(_ startColor: UIColor?) {
        self.startColor = startColor
        setNeedsLayout()
    }
    
    public func setEndColor(_ endColor: UIColor?) {
        self.endColor = endColor ?? .clear
        setNeedsLayout()
    }
    
    private func addGradient() {
        guard let startColor = startColor else { return }
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.shouldRasterize = true
        switch style {
        case .light:
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.25)
        case .medium:
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.5)
        case .hard:
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.7)
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
