//
//  BrowseSectionHeaderView.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 13.03.2022.
//

import UIKit

class TextHeader: UICollectionReusableView {
    
    static let id = "TextHeader"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25, weight: .semibold)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-5)
            make.bottom.equalToSuperview().offset(-5)
            make.top.equalToSuperview().offset(15)
        }
    }
    
    func setTitle(_ text: String?) {
        titleLabel.text = text
    }
}
