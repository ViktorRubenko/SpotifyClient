//
//  SearchViewController.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 10.03.2022.
//

import UIKit

class SearchViewController: UIViewController {
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: SearchResultsController())
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
            SuggestionGroupViewCell.self,
            forCellWithReuseIdentifier: SuggestionGroupViewCell.id)
        return collectionView
    }()
    private let viewModel = searchViewModel()
    private let colors: [UIColor] = [
        .systemGreen,
        .systemBlue,
        .systemRed,
        .systemGray,
        .systemPink,
        .systemPurple,
        .systemBrown,
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupViews()
    }
}
//MARK: - Methods
extension SearchViewController {
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        let safeArea = view.safeAreaLayoutGuide
        
//        view.addSubview(segmentedControl)
//        segmentedControl.snp.makeConstraints { make in
//            make.top.equalTo(safeArea)
//            make.leading.equalToSuperview()
//            make.trailing.equalToSuperview()
//        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.searchController = searchController
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(110))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(15)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 15
        
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
//MARK: CollectionView Delegate/DataSource
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SuggestionGroupViewCell.id,
            for: indexPath) as! SuggestionGroupViewCell
        cell.configure(title: "Rok", backgroundColor: colors[indexPath.row % colors.count])
        return cell
    }
}
