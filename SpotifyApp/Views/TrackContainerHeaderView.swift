//
//  AlbumHeaderView.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 14.03.2022.
//

import UIKit

class TrackContainerHeaderView: UICollectionReusableView {
    
    static let id = "AlbumHeaderView"
    
    private let topLabel: UILabel = {
        let label = UILabel()
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
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public func configure(_ model: TrackContainerHeaderModel, type: TrackContainerType = .album) {
        if type == .playlist {
            topLabel.font = .systemFont(ofSize: 13, weight: .light)
            middleLabel.font = .systemFont(ofSize: 14, weight: .regular)
            bottomLabel.font = .systemFont(ofSize: 13, weight: .light)
        }
        topLabel.text = model.topText
        middleLabel.text = model.middleText
        bottomLabel.text = model.bottomText
    }
}
