//
//  LibraryViewController.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 10.03.2022.
//

import UIKit

class LibraryViewController: UIViewController {
    
    private var viewModel: LibraryViewModel!
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, _ in
                self.createSection(sectionIndex)
            }))
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ItemListCell.self, forCellWithReuseIdentifier: ItemListCell.id)
        return collectionView
    }()
    
    init(viewModel: LibraryViewModel? = nil) {
        super.init(nibName: nil, bundle: nil)
        if let viewModel = viewModel {
            self.viewModel = viewModel
        } else {
            self.viewModel = LibraryViewModel()
        }
        
        self.viewModel.fetch()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupBinders()
    }
}
// MARK: - Methods
extension LibraryViewController {
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupBinders() {
        viewModel.tracks.bind { [weak self] tracks in
            guard let strongSelf = self else { return }
            if strongSelf.collectionView.numberOfItems(inSection: 0) == 0 {
                strongSelf.collectionView.reloadData()
            } else {
                strongSelf.addNextTracks(tracks)
            }
        }
        
        viewModel.playingTrackID.bind { [weak self] _ in
            self?.collectionView.reloadData()
        }
    }
    
    private func addNextTracks(_ tracks: [ItemModel]) {
        collectionView.performBatchUpdates {
            let totalCells = collectionView.numberOfItems(inSection: 0)
            let indexPaths = tracks[totalCells...].enumerated().compactMap { index, _ in
                IndexPath(row: index, section: 0)
            }
            collectionView.insertItems(at: indexPaths)
        }
    }
    
    private func createSection(_ sectionIndex: Int) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(55)),
            subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 3
        
        return section
    }
}
// MARK: - CollectionView Delegate/DataSource
extension LibraryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemListCell.id, for: indexPath) as! ItemListCell
        let model = viewModel.tracks.value[indexPath.row]
        cell.configure(model)
//        cell.isPlaying = false
        if model.id == viewModel.playingTrackID.value {
            cell.isPlaying = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.tracks.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let averageColor = (collectionView.cellForItem(at: indexPath) as? AverageColorProtocol)?.averageColor
        let coordinator = PlayerViewControllerCoordinator(
            trackIndex: indexPath.row,
            trackResponses: viewModel.trackResponses,
            container: tabBarController!,
            nextURL: viewModel.nextURL,
            averageColor: averageColor)
        coordinator.start()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.tracks.value.count / 2 {
            viewModel.fetchNext()
        }
    }
}
