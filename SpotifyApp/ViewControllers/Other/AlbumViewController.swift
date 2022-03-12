//
//  AlbumViewController.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 13.03.2022.
//

import UIKit

class AlbumViewController: UIViewController {
    
    private var viewModel: AlbumViewModel!
    private var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupNavigationBar()
        setupBinders()
        
        viewModel.fetch()
        
    }
    
    init(id: String) {
        self.viewModel = AlbumViewModel(id: id)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
//MARK: - Methods
extension AlbumViewController {
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func setupBinders() {
        viewModel.album.bind { [weak self] _ in
            self?.tableView.reloadData()
        }
    }
}
//MARK: - TableView Delegate/DataSource
extension AlbumViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(viewModel.album.value)
        return viewModel.album.value.tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var contentConfig = cell.defaultContentConfiguration()
        contentConfig.text = viewModel.album.value.tracks[indexPath.row].name
        cell.contentConfiguration = contentConfig
        return cell
    }
}
