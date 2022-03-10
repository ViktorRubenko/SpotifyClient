//
//  SettingsViewController.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 10.03.2022.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private var viewModel: SettingsViewModel!
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingsCell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = SettingsViewModel()
        viewModel.delegate = self
        
        title = "Settings"

        setupViews()
        setupNavigationBar()
    }

}
//MARK: - Methods
extension SettingsViewController {
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupNavigationBar() {
        
    }
    
    private func configureModels() {
        
    }
}
//MARK: SettingsViewModel delegate
extension SettingsViewController: SettingsViewModelDelegate {
    func openUserProfile() {
        let profileVC = UserProfileViewController()
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    func signOut() {
        print("signOut")
    }
}
//MARK: - TableView Delegate/DataSource
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.sections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let option = viewModel.sections[indexPath.section].options[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
        var contentConfig = cell.defaultContentConfiguration()
        contentConfig.text = option.title
        cell.contentConfiguration = contentConfig
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = viewModel.sections[indexPath.section].options[indexPath.row]
        option.handler()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = viewModel.sections[section]
        return section.title
    }
}
