//
//  TrackViewCell.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 13.03.2022.
//

import UIKit
import SnapKit

class ItemListCell: UICollectionViewListCell {
    static let id = "TrackListCell"
    
    private let indexLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .light)
        return label
    }()
    
    private let accessoryButton: UIButton = {
        let button = UIButton()
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.addTarget(self, action: #selector(didTapAccessotyButton), for: .touchUpInside)
        button.backgroundColor = .clear
        return button
    }()
    
    var accessoryHandler: (() -> Void)?
    
    private lazy var customAccessory = UICellAccessory.CustomViewConfiguration(
        customView: accessoryButton, placement: .trailing(displayed: .always))
    
    private var imageLeadingContraint: Constraint!
    private var imageWidthContraint: Constraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        accessories = [.customView(configuration: customAccessory)]
        setupBackground()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        infoLabel.text = nil
        imageView.image = UIImage(systemName: "photo")
    }
    
    private func setupBackground() {
        var bgConfig = UIBackgroundConfiguration.listGroupedCell()
        bgConfig.backgroundColor = UIColor(named: "SubBGColor")?.withAlphaComponent(0.5)
        backgroundConfiguration = bgConfig
    }
    
    var averageColor: UIColor? {
        imageView.image?.averageColor
    }
    
    private func setupViews() {
        
        contentView.addSubview(indexLabel)
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(infoLabel)
        
        indexLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalTo(40)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            imageLeadingContraint = make.leading.equalTo(indexLabel.snp.trailing).offset(4).constraint
            imageWidthContraint = make.width.equalTo(imageView.snp.height).constraint
        }
        
        nameLabel.snp.makeConstraints { make in
            make.bottom.equalTo(imageView.snp.centerY)
            make.leading.equalTo(imageView.snp.trailing).offset(4)
            make.trailing.equalToSuperview().offset(-2)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel)
            make.trailing.equalTo(nameLabel)
            make.top.equalTo(imageView.snp.centerY).offset(2)
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    func configure(_ model: CellModel, type: ItemType = .track, index: String? = nil, useDefaultImage: Bool = false) {
        switch type {
        case .track:
            accessoryButton.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
        case .album, .playlist, .artist:
            accessoryButton.setImage(UIImage(systemName: "chevron.forward.circle"), for: .normal)
        default:
            break
        }
        nameLabel.text = model.name
        infoLabel.text = model.info
        indexLabel.text = index
        
        if useDefaultImage {
            switch type {
            case .track:
                imageView.image = UIImage(systemName: "music.note")
            case .artist:
                imageView.image = UIImage(systemName: "music.mic")
            case .album:
                imageView.image = UIImage(systemName: "circle")
            case .playlist:
                imageView.image = UIImage(systemName: "play.circle")
            default:
                break
            }
        }
        
        if model.imageURL != nil {
            imageView.sd_setImage(with: model.imageURL, completed: nil)
        }
        
        if index == nil {
            imageLeadingContraint.deactivate()
            imageView.snp.makeConstraints { make in
                imageLeadingContraint = make.leading.equalToSuperview().constraint
            }
        }
        if !useDefaultImage && model.imageURL == nil {
            imageWidthContraint.deactivate()
            imageView.snp.makeConstraints { make in
                imageWidthContraint = make.width.equalTo(0).constraint
            }
        }
    }
    
    @objc private func didTapAccessotyButton() {
        accessoryHandler?()
    }
}
