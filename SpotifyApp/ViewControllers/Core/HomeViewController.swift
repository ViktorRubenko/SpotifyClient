//
//  HomeViewController.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 10.03.2022.
//

import UIKit

fileprivate enum BrowseSectionType {
    case newReleases, featuredPlaylists, recommendations, unknown
}

class HomeViewController: UIViewController {
    
    private var viewModel: HomeViewModel!
    private var collectionView: UICollectionView!
    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let sections: [BrowseSectionType] = [.newReleases, .featuredPlaylists, .recommendations, .unknown]
    
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
        let section = section < sections.count ? sections[section] : .unknown
        switch section {
        case .featuredPlaylists:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension:.fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(180), heightDimension: .absolute(360))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 2)
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            
            return section
        case .recommendations:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 2, bottom: 4, trailing: 2)
            
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
            
            let section = NSCollectionLayoutSection(group: group)
            
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
        let section = indexPath.section < sections.count ? sections[indexPath.section] : .unknown
        let data = viewModel.sections.value[indexPath.section].items[indexPath.row]
        switch section {
        case .newReleases:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NewReleasesCollectionViewCell.identifier,
                for: indexPath) as! NewReleasesCollectionViewCell
            cell.configure(data)
            return cell
        case .featuredPlaylists:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier,
                for: indexPath) as! FeaturedPlaylistCollectionViewCell
            cell.configure(data)
            return cell
        case .recommendations:
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = indexPath.section < sections.count ? sections[indexPath.section] : .unknown
        let item = viewModel.sections.value[indexPath.section].items[indexPath.row]
        switch section {
        case .newReleases:
            let vc = AlbumViewController(id: item.id)
            vc.title = item.name
            navigationController?.pushViewController(vc, animated: true)
        case .featuredPlaylists:
            let playlist = viewModel.sections.value[indexPath.section].items[indexPath.row]
        case .recommendations:
            let track = viewModel.sections.value[indexPath.section].items[indexPath.row]
        default:
            break
        }
    }
}
