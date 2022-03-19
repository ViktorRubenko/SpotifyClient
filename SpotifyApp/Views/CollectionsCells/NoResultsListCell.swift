//
//  NoResultsListCell.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 17.03.2022.
//

import UIKit

class NoResultsListCell: UICollectionViewListCell {
    
    static let id = "NoResultsListCell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "No Results"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    override func layoutSubviews() {
        backgroundColor = UIColor(named: "SubBGColor")!.withAlphaComponent(0.5)
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
