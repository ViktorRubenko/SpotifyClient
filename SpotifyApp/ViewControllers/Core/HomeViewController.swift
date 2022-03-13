//
//  HomeViewController.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 10.03.2022.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var viewModel: HomeViewModel!
    private lazy var collectionView: UICollectionView = {
        let  collectionView = UICollectionView(
            frame: .zero, collectionViewLayout:
                UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, _ in
                    self.createSectionLayout(section: sectionIndex)
                }))
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            AlbumViewCell.self,
            forCellWithReuseIdentifier: AlbumViewCell.identifier)
        collectionView.register(
            FeaturedPlaylistCollectionViewCell.self,
            forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier)
        collectionView.register(
            TrackViewCell.self,
            forCellWithReuseIdentifier: TrackViewCell.identifier)
        collectionView.register(
            UserPlaylistCollectionViewCell.self,
            forCellWithReuseIdentifier: UserPlaylistCollectionViewCell.id)
        collectionView.register(
            BrowseSectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: BrowseSectionHeaderView.id)
        return collectionView
    }()
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
        let section = BrowseSectionType(fromRawValue: section)
        switch section {
        case .userPlaylists:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension:.fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 3, bottom: 3, trailing: 2)
            
            
            let hGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))
            let hGroup = NSCollectionLayoutGroup.horizontal(layoutSize: hGroupSize, subitem: item, count: 2)
            
            let section = NSCollectionLayoutSection(group: hGroup)
            section.orthogonalScrollingBehavior = .continuous

            
            return section
        case .recentlyPlayed, .recommendations:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension:.fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 6)
            
            
            let hGroupSize = NSCollectionLayoutSize(widthDimension: .absolute(110), heightDimension: .absolute(140))
            let hGroup = NSCollectionLayoutGroup.horizontal(layoutSize: hGroupSize, subitem: item, count: 1)
            
            let section = NSCollectionLayoutSection(group: hGroup)
            section.orthogonalScrollingBehavior = .continuous
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
            section.boundarySupplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)]
            
            return section
        case .newReleases:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension:.fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 8)
            
            
            let hGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let hGroup = NSCollectionLayoutGroup.horizontal(layoutSize: hGroupSize, subitem: item, count: 1)
            let vGroupSize = NSCollectionLayoutSize(widthDimension: .absolute(140), heightDimension: .absolute(380))
            let vGroup = NSCollectionLayoutGroup.vertical(layoutSize: vGroupSize, subitem: hGroup, count: 2)
            
            let section = NSCollectionLayoutSection(group: vGroup)
            section.orthogonalScrollingBehavior = .continuous
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
            section.boundarySupplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)]
            
            return section
        case .featuredPlaylists:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension:.fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(160), heightDimension: .absolute(320))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 2)
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
            section.boundarySupplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)]
            
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
        let section = BrowseSectionType(fromRawValue: indexPath.section)
        let model = viewModel.sections.value[indexPath.section].items[indexPath.row]
        switch section {
        case .userPlaylists:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: UserPlaylistCollectionViewCell.id,
                for: indexPath) as! UserPlaylistCollectionViewCell
            cell.configure(model)
            return cell
        case .newReleases:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: AlbumViewCell.identifier,
                for: indexPath) as! AlbumViewCell
            cell.configure(model)
            return cell
        case .featuredPlaylists:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier,
                for: indexPath) as! FeaturedPlaylistCollectionViewCell
            cell.configure(model)
            return cell
        case .recommendations, .recentlyPlayed:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TrackViewCell.identifier,
                for: indexPath) as! TrackViewCell
            cell.configure(model)
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackViewCell.identifier, for: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = BrowseSectionType(fromRawValue: indexPath.section)
        let item = viewModel.sections.value[indexPath.section].items[indexPath.row]
        switch section {
        case .userPlaylists:
            break
        case .newReleases:
            let vc = AlbumViewController(id: item.id)
            navigationController?.pushViewController(vc, animated: true)
        case .featuredPlaylists:
            let playlist = viewModel.sections.value[indexPath.section].items[indexPath.row]
        case .recommendations:
            let track = viewModel.sections.value[indexPath.section].items[indexPath.row]
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let title = viewModel.sections.value[indexPath.section].title
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: BrowseSectionHeaderView.id, for: indexPath) as! BrowseSectionHeaderView
        view.setTitle(title)
        return view
    }
}
