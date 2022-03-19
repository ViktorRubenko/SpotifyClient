//
//  SectionBackgroundView.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 19.03.2022.
//

import UIKit

class SectionBackgroundView: UICollectionReusableView {
    static let id = "SectionBackgroundUICollectionReusableView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
