//
//  FeaturedPlaylistCollectionViewCell.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 12.03.2022.
//

import UIKit

class FullImageCollectionViewCell: UICollectionViewCell {
    static let identifier = "FullImageCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
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
        imageView.image = UIImage(systemName: "photo")
    }
    
    private func setupViews() {
        backgroundColor = .clear
        
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(2)
            make.trailing.equalToSuperview().offset(-2)
            make.top.equalToSuperview().offset(2)
            make.height.equalTo(imageView.snp.width)
        }
    }
    
    func configure(_ model: CellModel) {
        imageView.sd_setImage(with: model.imageURL, completed: nil)
    }
}

extension FullImageCollectionViewCell: AverageColorProtocol {
    var averageColor: UIColor? {
        imageView.image?.averageColor
    }
}
