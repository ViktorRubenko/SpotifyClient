//
//  SuggestionGroupViewCell.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 15.03.2022.
//

import UIKit

class CategoryViewCell: UICollectionViewCell {
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
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = nil
    }
    
    private func setupViews() {
        clipsToBounds = true
        layer.cornerRadius = 10
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(10)
            make.top.equalTo(contentView.snp.centerY)
            make.trailing.equalToSuperview().offset(5)
            make.width.equalTo(imageView.snp.height)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    public func configure(_ model: CategoryCellModel, backgroundColor: UIColor) {
        titleLabel.text = model.name
        imageView.sd_setImage(with: model.iconURL, completed: nil)
        self.backgroundColor = backgroundColor
    }
}
