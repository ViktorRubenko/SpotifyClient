//
//  AlbumHeaderView.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 14.03.2022.
//

import UIKit

class TrackContainerHeaderView: UICollectionReusableView {
    
    static let id = "AlbumHeaderView"
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let artistsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        return label
    }()
    
    private let albumInfoLabel: UILabel = {
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
        stackView.addArrangedSubview(albumNameLabel)
        stackView.addArrangedSubview(artistsLabel)
        stackView.addArrangedSubview(albumInfoLabel)
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public func configure(_ model: TrackContainerHeaderModel) {
        albumNameLabel.text = model.name
        albumInfoLabel.text = model.info
        artistsLabel.text = model.artists
    }
}
