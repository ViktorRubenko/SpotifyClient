//
//  HomeViewController.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 10.03.2022.
//

import UIKit

fileprivate enum BrowseSectionType {
    case newReleases, featuredPlaylists, recommendations
}

class HomeViewController: UIViewController {
    
    private var viewModel: HomeViewModel!
    private var collectionView: UICollectionView!
    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = HomeViewModel()
        
        setupViews()
        setupNavigationBar()
        setupBinders()
        
        fetchData()
    }
}

// MARK: - Methods
extension HomeViewController {
    
    
    private func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
        switch section {
        case 1:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension:.fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(180), heightDimension: .absolute(360))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 2)
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            
            return section
        case 2:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 2, bottom: 4, trailing: 2)
            
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
            
            let section = NSCollectionLayoutSection(group: group)
            
            return section
        case 3:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension:.fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(360))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 3)
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            
            return section
        default:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension:.fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(230), heightDimension: .absolute(300))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 3)
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            
            return section
        }
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        collectionView = UICollectionView(
            frame: .zero, collectionViewLayout:
                UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, _ in
                    self.createSectionLayout(section: sectionIndex)
                }))
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(NewReleasesCollectionViewCell.self, forCellWithReuseIdentifier: NewReleasesCollectionViewCell.identifier)
        collectionView.register(FeaturedPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier)
        collectionView.register(RecommendationTrackViewCell.self, forCellWithReuseIdentifier: RecommendationTrackViewCell.identifier)
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .done,
            target: self,
            action: #selector(didTapSettings))
    }
    
    private func setupBinders() {
        viewModel.sections.bind { [weak self] _ in
            self?.activityIndicator.stopAnimating()
            self?.collectionView.reloadData()
        }
    }
    
    private func fetchData() {
        activityIndicator.startAnimating()
        viewModel.fetchData()
    }
}
//MARK: - Actions
extension HomeViewController {
    @objc private func didTapSettings() {
        let settingsVC = SettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
}
//MARK: - CollectionView Delegate/DataSource
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.sections.value[section].items.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.sections.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = viewModel.sections.value[indexPath.section].items[indexPath.row]
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NewReleasesCollectionViewCell.identifier,
                for: indexPath) as! NewReleasesCollectionViewCell
            cell.configure(data)
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier,
                for: indexPath) as! FeaturedPlaylistCollectionViewCell
            cell.configure(data)
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RecommendationTrackViewCell.identifier,
                for: indexPath) as! RecommendationTrackViewCell
            cell.configure(data)
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewReleasesCollectionViewCell.identifier, for: indexPath)
            return cell
        }
    }
}
