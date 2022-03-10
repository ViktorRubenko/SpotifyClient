//
//  UserProfileViewController.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 10.03.2022.
//

import UIKit
import SnapKit

class UserProfileViewController: UIViewController {
    
    private var viewModel: UserProfileViewModel!
    private var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = UserProfileViewModel()
        
        title = "Profile"
        
        setupBinders()
        setupViews()
        setupNavigationBar()
        
        viewModel.fetch()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Make imageView looks like a circle
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
    }
}
    
//MARK: - Methods
extension UserProfileViewController {
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.33)
            make.height.equalTo(profileImageView.snp.height)
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
        }
    }
    
    private func setupBinders() {
        viewModel.userImageURL.bind { [weak self] imageURL in
            if let urlString = imageURL {
                self?.profileImageView.imageFromURL(urlString: urlString)
            }
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
    }
}
