//
//  ImageHeaderView.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 13.03.2022.
//

import UIKit
import SnapKit

class ImageHeaderView: UIView {
    
    static let id = "ImageHeaderView"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "music.note")
        return imageView
    }()
    
    private var imageHeight = 250.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    init(imageHeight: Double) {
        super.init(frame: .zero)
        self.imageHeight = imageHeight
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var heightConstraint: Constraint!
    
    private func setupViews() {
        addSubview(imageView)

        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            heightConstraint = make.height.equalTo(imageHeight).constraint
            make.width.equalTo(imageView.snp.height)
        }
    }
    
    func setImage(_ url: URL?) {
        imageView.sd_setImage(with: url, completed: nil)
    }
    
    func scroll(_ yOffset: Double) {
        
        isHidden = yOffset > 180
        alpha = (180 - yOffset) / 180.0
        var height = imageHeight - yOffset / 2
        height = height >= 0 ? height : 0
        
        heightConstraint.deactivate()
        imageView.snp.makeConstraints { make in
            heightConstraint = make.height.equalTo(height).constraint
        }
    }
}
