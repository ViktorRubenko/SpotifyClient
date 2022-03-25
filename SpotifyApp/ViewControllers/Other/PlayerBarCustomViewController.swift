//
//  NonPanBarViewController.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 23.03.2022.
//

import UIKit
import LNPopupController

class PlayerBarCustomViewController: LNPopupCustomBarViewController {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    let progressBar: UIProgressView = {
        let progressBar = UIProgressView()
        progressBar.tintColor = .white
        progressBar.backgroundColor = .systemGray
        return progressBar
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .light)
        return label
    }()
    let button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        preferredContentSize = CGSize(width: 0, height: 55)
    }
    
    private func setupViews() {
        view.clipsToBounds = true
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.width.equalTo(imageView.snp.height)
        }
        
        view.addSubview(progressBar)
        progressBar.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalTo(2)
            make.bottom.equalToSuperview()
        }
        
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalToSuperview().multipliedBy(0.8)
            make.width.equalTo(button.snp.height)
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(10)
            make.trailing.equalTo(button.snp.leading)
            make.bottom.equalTo(view.snp.centerY).offset(-3)
        }
        
        view.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.trailing.equalTo(titleLabel)
            make.top.equalTo(view.snp.centerY).offset(3)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imageView.layer.cornerRadius = imageView.bounds.height * 0.2
    }
    
    override func popupItemDidUpdate() {
        super.popupItemDidUpdate()
        imageView.image = popupItem.image
        progressBar.progress = popupItem.progress
        titleLabel.text = popupItem.title
        subtitleLabel.text = popupItem.subtitle
        
        if let itemButton = popupItem.trailingBarButtonItems?.last {
            button.removeTarget(nil, action: nil, for: .allEvents)
            button.addTarget(itemButton.target, action: itemButton.action!, for: .touchUpInside)
            button.setImage(itemButton.image, for: .normal)
        }
    }
    
    override var wantsDefaultPanGestureRecognizer: Bool {
        return false
    }
}
