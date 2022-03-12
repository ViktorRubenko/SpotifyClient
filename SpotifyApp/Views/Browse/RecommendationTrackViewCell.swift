//
//  RecommendationsViewCell.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 12.03.2022.
//

import UIKit

class RecommendationTrackViewCell: UICollectionViewCell {
    static let identifier = "RecommendationsViewCell"
    
    private let trackNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()
    
    private let trackInfoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .light)
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
        trackNameLabel.text = nil
        trackInfoLabel.text = nil
        albumImageView.image = UIImage(systemName: "photo")
    }
    
    private func setupViews() {
        contentView.addSubview(albumImageView)
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(trackInfoLabel)
        
        albumImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(albumImageView.snp.height)
        }
        
        trackNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(albumImageView.snp.trailing).offset(10)
            make.bottom.equalTo(albumImageView.snp.centerY)
            make.top.greaterThanOrEqualTo(albumImageView)
            make.trailing.equalToSuperview()
        }
        
        trackInfoLabel.snp.makeConstraints { make in
            make.leading.equalTo(trackNameLabel)
            make.top.equalTo(albumImageView.snp.centerY).offset(4)
            make.bottom.lessThanOrEqualToSuperview()
            make.trailing.equalTo(trackNameLabel)
        }
    }
    
    func configure(_ viewModel: CellModel) {
        guard let viewModel = viewModel as? RecommendationTrackCellModel else {
            return
        }
        trackNameLabel.text = viewModel.name
        trackInfoLabel.text = "\(viewModel.type) • \(viewModel.artistsName)"
        albumImageView.sd_setImage(with: viewModel.albumImageURL, completed: nil)
    }
}
