//
//  FeaturedPlaylistCollectionViewCell.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 12.03.2022.
//

import UIKit

class FeaturedPlaylistCollectionViewCell: UICollectionViewCell {
    static let identifier = "FeaturedPlaylistCollectionViewCell"
    
    private let playlistImageView: UIImageView = {
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
        playlistImageView.image = UIImage(systemName: "photo")
    }
    
    private func setupViews() {
        backgroundColor = .clear
        
        contentView.addSubview(playlistImageView)
        
        playlistImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(2)
            make.trailing.equalToSuperview().offset(-2)
            make.top.equalToSuperview().offset(2)
            make.height.equalTo(playlistImageView.snp.width)
        }
    }
    
    func configure(_ viewModel: CellModel) {
        guard let viewModel = viewModel as? PlaylistModel else {
            return
        }
        playlistImageView.sd_setImage(with: viewModel.imageURL, completed: nil)
    }
}
