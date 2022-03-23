//
//  AlbumHeaderView.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 14.03.2022.
//

import UIKit

class TrackContainerHeaderView: UICollectionReusableView {
    
    static let id = "TrackContainerHeaderView"
    
    private let topLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let middleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        return label
    }()
    
    private let bottomLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .regular)
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.distribution = .equalCentering
        return stackView
    }()
    
    private lazy var playButton: UIButton = {
        let button = UIButton(type: .system)
        
        let imageConfig = UIImage.SymbolConfiguration.init(scale: .large)
        let image = UIImage(systemName: "play.fill", withConfiguration: imageConfig)
        
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.clipsToBounds = true
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = buttonSize / 2.0
        button.addTarget(self, action: #selector(didTapPlayButton), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    private let buttonSize = 55.0
    private var buttonCallback: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        stackView.addArrangedSubview(topLabel)
        stackView.addArrangedSubview(middleLabel)
        stackView.addArrangedSubview(bottomLabel)
        
        addSubview(playButton)
        playButton.snp.makeConstraints { make in
            make.width.equalTo(buttonSize)
            make.height.equalTo(buttonSize)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview()
        }
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.trailing.equalTo(playButton.snp.leading).offset(-2)
        }
    }
    
    @objc func didTapPlayButton() {
        buttonCallback?()
    }
    
    public func configure(_ model: TrackContainerHeaderModel, type: TrackContainerType = .album) {
        if type == .playlist {
            topLabel.font = .systemFont(ofSize: 12, weight: .light)
            middleLabel.font = .systemFont(ofSize: 13, weight: .regular)
            bottomLabel.font = .systemFont(ofSize: 12, weight: .light)
        }
        topLabel.text = model.topText
        middleLabel.text = model.middleText
        bottomLabel.text = model.bottomText
        playButton.isHidden = false
    }
    
    public func setPlayButtonCallback(_ callback: @escaping () -> Void) {
        buttonCallback = callback
    }
}
