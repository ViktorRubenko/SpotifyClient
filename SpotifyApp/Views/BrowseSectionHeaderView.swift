//
//  BrowseSectionHeaderView.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 13.03.2022.
//

import UIKit

class BrowseSectionHeaderView: UICollectionReusableView {
    
    static let id = "BrowseSectionHeaderView"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25, weight: .semibold)
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
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(25)
        }
    }
    
    func setTitle(_ text: String?) {
        titleLabel.text = text
    }
}
