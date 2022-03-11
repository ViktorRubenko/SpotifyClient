//
//  UserProfileHeader.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 10.03.2022.
//

import UIKit

class UserProfileHeader: UITableViewHeaderFooterView {
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
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
        
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.33)
            make.height.equalTo(profileImageView.snp.width)
            make.centerX.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(15)
        }
        
        addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(15)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-15)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Make imageView looks like a circle
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
    }
}
