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
        button.setTitleColor(.systemBackground, for: .normal)
        button.backgroundColor = .label
        return button
    }()
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "SpotifyIcon")
        return imageView
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.isHidden = true
        return activityIndicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Spotify"
        
        setupViews()
        setupAnimation()
    }
}

// MARK: - Methods
extension WelcomeViewController {
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(safeArea).multipliedBy(0.7)
            make.height.equalTo(logoImageView.snp.width)
        }
        
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        view.addSubview(signInButton)
        signInButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeArea)
            make.centerX.equalTo(safeArea)
            make.width.equalTo(safeArea).multipliedBy(0.7)
            make.height.equalTo(50)
        }
        signInButton.addTarget(self, action: #selector(tapSignIn), for: .touchUpInside)
    }
    
    func setupAnimation() {
        UIView.animate(
            withDuration: 2,
            delay: 0.5,
            options: [.autoreverse, .repeat],
            animations: {
                self.logoImageView.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
            })
    }
    
    private func handleSignIn(success: Bool) {
        guard success else { return }
        
        let mainTabBarController = TabBarController()
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
    }
}

// MARK: - Acitons
extension WelcomeViewController {
    @objc func tapSignIn() {
        logoImageView.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        AuthManager.shared.openAuthSession(presentationContextProvider: self) { [weak self] success in
            self?.activityIndicator.stopAnimating()
            self?.logoImageView.isHidden = false
            self?.handleSignIn(success: success)
        }
    }
}

extension WelcomeViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        ASPresentationAnchor()
    }
}
