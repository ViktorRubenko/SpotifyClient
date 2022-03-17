//
//  SearchViewController.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 10.03.2022.
//

import UIKit

class SearchViewController: UIViewController {
    private lazy var searchResultsController: SearchResultsViewController = {
        let controller = SearchResultsViewController(viewModel: self.viewModel)
        controller.delegate = self
        return controller
    }()
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(
            searchResultsController: searchResultsController)
        searchController.searchBar.placeholder = "Artists, songs and albums"
        searchController.searchBar.delegate = self
        return searchController
    }()
    private let segmentedItems = [
        "Best match",
        "Tracks",
        "Artists",
        "Albums",
        "Playlists",
    ]
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: segmentedItems)
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            CategoryViewCell.self,
            forCellWithReuseIdentifier: CategoryViewCell.id)
        return collectionView
    }()
    private let viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupViews()
        setupBinders()
        
        viewModel.fetchCategories()
    }
}
//MARK: - Methods
extension SearchViewController {
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.searchController = searchController
    }
    
    private func setupBinders() {
        viewModel.categories.bind { [weak self] _ in
            self?.collectionView.reloadData()
        }
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(110))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func performSearch() {
        viewModel.performSearch(for: searchController.searchBar.text!)
    }
}
//MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        performSearch()
    }
}
//MARK: - CollectionView Delegate/DataSource
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.categories.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = viewModel.categories.value[indexPath.row]
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CategoryViewCell.id,
            for: indexPath) as! CategoryViewCell
        cell.configure(model, backgroundColor: ColorPicker.getColor())
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = PlaylistsViewController(viewModel: viewModel.createPlaylistsViewModel(index: indexPath.row))
        navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK: - SearchResultsViewControllerDelegate
extension SearchViewController: SearchResultsViewControllerDelegate {
    func selectResultAt(indexPath: IndexPath, averageColor: UIColor?) {
        print(indexPath)
        let model = viewModel.resultSections.value[indexPath.section].items[indexPath.row]
        switch model.type {
        case .album:
            let vc = TrackContainerViewController(
                viewModel: AlbumViewModel(id: model.id),
                containerType: .album,
                imageAverageColor: averageColor)
            navigationController?.pushViewController(vc, animated: true)
        case .playlist:
            let vc = TrackContainerViewController(
                viewModel: PlaylistViewModel(id: model.id),
                containerType: .playlist,
                imageAverageColor: averageColor)
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}
