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

    func setupViews() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(signInButton)
        signInButton.center = view.center
        signInButton.addTarget(self, action: #selector(tapSignIn), for: .touchUpInside)
    }
}

//MARK: - Acitons
extension WelcomeViewController {
    @objc func tapSignIn() {
        AuthManager.shared.openAuthSession(presentationContextProvider: self) { success in
            print(success)
        }
    }
}

extension WelcomeViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        ASPresentationAnchor()
    }
}
