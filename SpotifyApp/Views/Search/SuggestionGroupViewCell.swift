//
//  SuggestionGroupViewCell.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 15.03.2022.
//

import UIKit

class SuggestionGroupViewCell: UICollectionViewCell {
    static let id = "SuggestionGroupViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "music.quarternote.3")
        imageView.contentMode = .scaleAspectFill
        imageView.transform = imageView.transform.rotated(by: .pi/8)
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        clipsToBounds = true
        layer.cornerRadius = 10
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.top.equalTo(contentView.snp.centerY)
            make.trailing.equalToSuperview()
            make.width.equalTo(imageView.snp.height)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    public func configure(title: String, backgroundColor: UIColor) {
        titleLabel.text = title
        self.backgroundColor = backgroundColor
    }
}
