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
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.register(UserProfileHeader.self, forHeaderFooterViewReuseIdentifier: "Header")
        return tableView
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
}
    
// MARK: - Methods
extension UserProfileViewController {
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupBinders() {
        viewModel.contents.bind { [weak self] _ in
            self?.tableView.reloadData()
        }
        
        viewModel.error.bind { [weak self] _ in
            self?.showErrorAlert()
        }
    }
    
    func showErrorAlert() {
        let alert = UIAlertController(
            title: NSLocalizedString("Woops...", comment: "ErrorAlertTitle UserProfile"),
            message: NSLocalizedString("Something gone wrong. Please, try later.", comment: "ErrorAlert UserProfile message"),
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alert, animated: true)
    }
    
    private func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
    }
}

// MARK: - TableView Delegate/DataSource
extension UserProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.contents.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let content = viewModel.contents.value[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var contentConfig = cell.defaultContentConfiguration()
        contentConfig.text = content
        cell.contentConfiguration = contentConfig
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header") as! UserProfileHeader
        view.profileImageView.sd_setImage(with: viewModel.userImageURL.value, completed: nil)
        view.userNameLabel.text = viewModel.userName.value
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        200
    }
}
