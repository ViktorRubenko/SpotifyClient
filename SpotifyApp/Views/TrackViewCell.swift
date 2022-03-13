//
//  TrackViewCell.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 13.03.2022.
//

import UIKit
import SnapKit

class TrackViewCell: UICollectionViewListCell {
    static let id = "TrackViewCell"
    
    private let trackNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
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
        label.font = .systemFont(ofSize: 12, weight: .light)
        return label
    }()
    
    private let customAccessory = UICellAccessory.CustomViewConfiguration(
        customView: UIImageView(image: UIImage(systemName: "ellipsis.circle")), placement: .trailing(displayed: .always))
    
    private var widthConstraint: Constraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        
        accessories = [.customView(configuration: customAccessory)]
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
        
        backgroundColor = .systemGreen
        
        albumImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            widthConstraint = make.width.equalTo(albumImageView.snp.height).constraint
        }
        
        trackNameLabel.snp.makeConstraints { make in
            make.bottom.equalTo(albumImageView.snp.centerY)
            make.leading.equalTo(albumImageView.snp.trailing).offset(2)
            make.trailing.equalToSuperview().offset(-2)
        }
        
        trackInfoLabel.snp.makeConstraints { make in
            make.leading.equalTo(trackNameLabel)
            make.trailing.equalTo(trackNameLabel)
            make.top.equalTo(albumImageView.snp.centerY).offset(2)
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
        if viewModel.albumImageURL == nil {
            widthConstraint.deactivate()
            albumImageView.snp.makeConstraints { make in
                widthConstraint = make.width.equalTo(0).constraint
            }
        }
    }
}