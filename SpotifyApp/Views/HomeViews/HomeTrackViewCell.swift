//
//  RecommendationsViewCell.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 12.03.2022.
//

import UIKit

class HomeTrackViewCell: UICollectionViewCell {
    static let identifier = "TrackViewCell"
    
    private let trackNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
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
        label.font = .systemFont(ofSize: 11, weight: .light)
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
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(albumImageView.snp.width)
        }
        
        trackNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(2)
            make.trailing.equalToSuperview().offset(-2)
            make.top.equalTo(albumImageView.snp.bottom).offset(2)
        }
        
        trackInfoLabel.snp.makeConstraints { make in
            make.leading.equalTo(trackNameLabel)
            make.trailing.equalTo(trackNameLabel)
            make.top.equalTo(trackNameLabel.snp.bottom)
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    func configure(_ viewModel: CellModel) {
        guard let viewModel = viewModel as? TrackModel else {
            return
        }
        trackNameLabel.text = viewModel.name
        trackInfoLabel.text = "\(viewModel.artistsName)"
        albumImageView.sd_setImage(with: viewModel.albumImageURL, completed: nil)
    }
}
