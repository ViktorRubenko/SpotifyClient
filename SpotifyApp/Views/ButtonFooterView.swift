//
//  ButtonFooterBiew.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 20.03.2022.
//

import UIKit

class ButtonFooterView: UICollectionReusableView {
    
    static let id = "ButtonFooterView"
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1.0
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }()
    
    var callback: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(button)
        button.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(30)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    func setButtonTitle(_ text: String?) {
        button.setTitle(text, for: .normal)
    }
    
    @objc func didTapButton() {
        callback?()
    }
}
