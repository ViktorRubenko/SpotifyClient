//
//  ImageTextHeader.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 16.03.2022.
//

import UIKit

class ImageTextHeader: UITableViewHeaderFooterView {
    
    static let id = "ImageTextHeader"
    
    private let containerView = UIView()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let topLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .light)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private let bottomLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .thin)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(topLabel)
        containerView.addSubview(bottomLabel)
        
        containerView.snp.makeConstraints { make in
            make.leading.equalTo(snp.leading)
            make.trailing.equalTo(snp.trailing)
            make.center.equalToSuperview()
            make.top.equalTo(imageView)
            make.bottom.equalTo(bottomLabel)
        }
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(snp.height).multipliedBy(0.6)
            make.width.equalTo(imageView.snp.height)
        }
        
        topLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        
        bottomLabel.snp.makeConstraints { make in
            make.top.equalTo(topLabel.snp.bottom).offset(4)
            make.leading.equalTo(topLabel)
            make.trailing.equalTo(topLabel)
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    func configure(imageURL: URL?, topText: String?, bottomText: String?) {
        imageView.sd_setImage(with: imageURL, completed: nil)
        topLabel.text = topText
        bottomLabel.text = bottomText
    }
}
