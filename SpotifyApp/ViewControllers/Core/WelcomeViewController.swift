//
//  WelcomeViewController.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 10.03.2022.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    let signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SignIn", for: .normal)
        button.sizeToFit()
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    func setupViews() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(signInButton)
        signInButton.center = view.center
    }
    
}
