//
//  HomeViewController.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 10.03.2022.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
}

// MARK: - Methods
extension HomeViewController {
    func setupViews() {
        view.backgroundColor = .systemBackground
        
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .done,
            target: self,
            action: #selector(didTapSettings))
    }
}
//MARK: - Actions
extension HomeViewController {
    @objc func didTapSettings() {
        let settingsVC = SettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
}
