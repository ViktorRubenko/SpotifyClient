//
//  NewReleasesCollectionViewCell.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 12.03.2022.
//

import UIKit
import SDWebImage

class ImageWithInfoCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ImageWithInfoCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let topLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bottomLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 13, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        topLabel.text = nil
        bottomLabel.text = nil
        imageView.image = nil
    }
    
    func configure(_ model: CellModel) {
        topLabel.text = model.name
        bottomLabel.text = model.info
        imageView.sd_setImage(with: model.imageURL, completed: nil)
    }
    
    private func setupViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(topLabel)
        contentView.addSubview(bottomLabel)
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
        }
        
        topLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(2)
            make.trailing.equalToSuperview().offset(-2)
        }
        
        bottomLabel.snp.makeConstraints { make in
            make.top.equalTo(topLabel.snp.bottom).offset(2)
            make.leading.equalTo(topLabel)
            make.trailing.equalTo(topLabel)
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
}

extension ImageWithInfoCollectionViewCell: AverageColorProtocol {
    var averageColor: UIColor? {
        imageView.image?.averageColor
    }
}
