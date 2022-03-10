//
//  WelcomeViewController.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 10.03.2022.
//

import UIKit
import AuthenticationServices

class WelcomeViewController: UIViewController {
    
    let signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SignIn", for: .normal)
        button.sizeToFit()
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Spotify"
        
        setupViews()
    }
}

// MARK: - Methods
extension WelcomeViewController {
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(signInButton)
        signInButton.center = view.center
        signInButton.addTarget(self, action: #selector(tapSignIn), for: .touchUpInside)
    }
    
    private func handleSignIn(success: Bool) {
        guard success else { return }
        
        let mainVC = TabBarController()
        mainVC.modalPresentationStyle = .fullScreen
        present(mainVC, animated: true)
    }
}

//MARK: - Acitons
extension WelcomeViewController {
    @objc func tapSignIn() {
        AuthManager.shared.openAuthSession(presentationContextProvider: self) { [weak self] success in
            self?.handleSignIn(success: success)
        }
    }
}

extension WelcomeViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        ASPresentationAnchor()
    }
}
