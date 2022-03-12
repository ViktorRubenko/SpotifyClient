//
//  NewReleasesCollectionViewCell.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 12.03.2022.
//

import UIKit
import SDWebImage

class NewReleasesCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "NewReleasesCollectionViewCell"
    
    private let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
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
        albumNameLabel.text = nil
        artistNameLabel.text = nil
        albumImageView.image = nil
    }
    
    func configure(_ viewModel: CellModel) {
        guard let viewModel = viewModel as? AlbumModel else {
            print("Failed to read NewReleasesCellModel")
            return
        }
        albumNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistsName
        albumImageView.sd_setImage(with: viewModel.imageURL, completed: nil)
    }
    
    private func setupViews() {
        
        backgroundColor = UIColor(named: "SubBGColor")
        
        contentView.addSubview(albumImageView)
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(artistNameLabel)
        
        albumImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(2)
            make.bottom.equalToSuperview().offset(-2)
            make.leading.equalToSuperview().offset(2)
            make.width.equalTo(albumImageView.snp.height)
        }
        
        albumNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(albumImageView.snp.trailing).offset(4)
            make.trailing.equalToSuperview().offset(-2)
            make.top.equalTo(albumImageView).offset(4)
        }
        
        artistNameLabel.snp.makeConstraints { make in
            make.top.equalTo(albumNameLabel.snp.bottom).offset(4)
            make.leading.equalTo(albumNameLabel)
            make.trailing.equalTo(albumNameLabel)
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
}
