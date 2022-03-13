//
//  AlbumViewController.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 13.03.2022.
//

import UIKit

class AlbumViewController: UIViewController {
    
    private var viewModel: AlbumViewModel!
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            TrackViewCell.self,
            forCellWithReuseIdentifier: TrackViewCell.id)
        collectionView.register(
            ImageHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ImageHeaderView.id)
        return collectionView
    }()
    private var headerView = ImageHeaderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupNavigationBar()
        setupBinders()
        
        print("fetch")
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
        
        let safeArea = view.safeAreaLayoutGuide
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(headerView)
        headerView.backgroundColor = .red
        headerView.snp.makeConstraints { make in
            make.top.equalTo(safeArea.snp.top)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        title = ""
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward.circle"),
            style: .done,
            target: self,
            action: #selector(didTapBackButton))
    }
    
    private func setupBinders() {
        viewModel.album.bind { [weak self] album in
            self?.collectionView.reloadData()
            self?.headerView.setImage(album.imageURL)
        }
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 2
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(250))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        section.boundarySupplementaryItems = [sectionHeader]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
//MARK: - Actions
extension AlbumViewController {
    @objc func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}
//MARK: - CollectionView Delegate/DataSource
extension AlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.album.value.tracks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = viewModel.album.value.tracks[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackViewCell.id, for: indexPath) as! TrackViewCell
        cell.configure(model)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        headerView.scroll(scrollView.contentOffset.y + 91)
    }
}
