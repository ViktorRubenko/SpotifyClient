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
    
    var accessotyHandler: (() -> Void)?
    
    private lazy var customAccessory = UICellAccessory.CustomViewConfiguration(
        customView: accessoryButton, placement: .trailing(displayed: .always))
    
    private var widthConstraint: Constraint!
    
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
        
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(infoLabel)
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            widthConstraint = make.width.equalTo(imageView.snp.height).constraint
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
    
    func configure(_ model: CellModel, type: ItemType = .track) {
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
        imageView.sd_setImage(with: model.imageURL, completed: nil)
        if model.imageURL == nil {
            widthConstraint.deactivate()
            imageView.snp.makeConstraints { make in
                widthConstraint = make.width.equalTo(0).constraint
            }
        }
    }
    
    @objc private func didTapAccessotyButton() {
        accessotyHandler?()
    }
}
