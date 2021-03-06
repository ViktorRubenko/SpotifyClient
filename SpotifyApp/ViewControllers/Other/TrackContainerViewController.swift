//
//  TrackContainerViewController.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 15.03.2022.
//

import UIKit
import SnapKit
import LNPopupController

enum TrackContainerType {
    case album, playlist
}

class TrackContainerViewController: UIViewController {
    
    private var viewModel: TrackContainerViewModelProtocol!
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            ItemListCell.self,
            forCellWithReuseIdentifier: ItemListCell.id)
        collectionView.register(
            TrackContainerHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackContainerHeaderView.id)
        return collectionView
    }()
    private let headerView = ImageHeaderView()
    private var headerConstraint: Constraint!
    private var backgroundGradientView = GradientBackgroundView()
    private var imageAverageColor: UIColor?
    private var previousNavigatioBarAppearance: UINavigationBarAppearance?
    private var containerType: TrackContainerType!
    private var needSetContentOffset = true
    private var topContentOffset = 0.0
    
    required init(
        viewModel: TrackContainerViewModelProtocol,
        containerType: TrackContainerType,
        imageAverageColor: UIColor? = nil) {
            self.viewModel = viewModel
            self.imageAverageColor = imageAverageColor
            self.containerType = containerType
            super.init(nibName: nil, bundle: nil)
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViews()
        setupBinders()
        
        viewModel.fetch()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let appearance = previousNavigatioBarAppearance else { return }
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    override func viewWillLayoutSubviews() {
        if needSetContentOffset {
            needSetContentOffset = false
            topContentOffset = view.bounds.width * 0.65
            collectionView.contentInset = UIEdgeInsets(top: topContentOffset, left: 0, bottom: 0, right: 0)
        }
    }
}
// MARK: - Methods
extension TrackContainerViewController {
    private func setupViews() {
        
        view.backgroundColor = .systemBackground
        
        let safeArea = view.safeAreaLayoutGuide
        
        backgroundGradientView.setStartColor(imageAverageColor)
        view.addSubview(backgroundGradientView)
        backgroundGradientView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.equalTo(safeArea.snp.top).offset(-30)
            headerConstraint = make.height.equalTo(view.snp.width).multipliedBy(0.65).constraint
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        view.addSubview(collectionView)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(safeArea)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        collectionView.backgroundColor = .clear
    }
    
    private func setupNavigationBar() {
        title = ""
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward.circle"),
            style: .done,
            target: self,
            action: #selector(didTapBackButton))
        
        previousNavigatioBarAppearance = navigationController?.navigationBar.scrollEdgeAppearance
        
        let transparentBackground = UINavigationBarAppearance()
        transparentBackground.configureWithTransparentBackground()
        transparentBackground.backgroundColor = .clear
        navigationController?.navigationBar.scrollEdgeAppearance = transparentBackground
    }
    
    private func setupBinders() {
        viewModel.fetched.bind { [weak self] _ in
            self?.collectionView.reloadData()
            self?.headerView.setImage(self?.viewModel.model?.imageURL)
        }
        
        viewModel.playingTrackID.bind { [weak self] _ in
            self?.collectionView.reloadData()
        }
        
        viewModel.fetchedNext.bind { [weak self] _ in
            self?.addNextCells()
        }
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 2
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        section.boundarySupplementaryItems = [sectionHeader]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func addNextCells() {
        print("batches")
        collectionView.performBatchUpdates {
            let totalItems = collectionView.numberOfItems(inSection: 0)
            for trackIndex in totalItems..<viewModel.tracks.count {
                collectionView.insertItems(at: [IndexPath(item: trackIndex, section: 0)])
            }
        }

    }
}
// MARK: - Actions
extension TrackContainerViewController {
    @objc func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}
// MARK: - CollectionView Delegate/DataSource
extension TrackContainerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.tracks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = viewModel.tracks[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemListCell.id, for: indexPath) as! ItemListCell
        cell.configure(model)
        cell.accessoryHandler = { [weak self] in
            let vc = TrackActionsViewController(
                viewModel: self!.viewModel.createTrackActionsViewModel(index: indexPath.row),
                averageColor: cell.averageColor)
            vc.modalPresentationStyle = .overFullScreen
            self?.present(vc, animated: true)
        }
        if let playingTrackID = viewModel.playingTrackID.value, playingTrackID == model.id {
            cell.isPlaying = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        default:
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: TrackContainerHeaderView.id,
                for: indexPath) as! TrackContainerHeaderView
            if let headerModel = viewModel.headerModel {
                headerView.configure(headerModel, type: containerType)
            }
            headerView.setPlayButtonCallback {
                let coordinator = PlayerViewControllerCoordinator(
                    trackIndex: self.viewModel.firstPlayeble,
                    trackResponses: self.viewModel.trackResponses,
                    container: self.tabBarController!,
                    nextURL: self.viewModel.nextURL,
                    averageColor: nil)
                coordinator.start()
            }
            return headerView
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        let coordinator = PlayerViewControllerCoordinator(
            trackIndex: indexPath.row,
            trackResponses: viewModel.trackResponses,
            container: tabBarController!,
            nextURL: viewModel.nextURL,
            averageColor: imageAverageColor)
        coordinator.start()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y + topContentOffset
        title = yOffset >= topContentOffset ? viewModel.model?.name : ""
        
        if yOffset <= topContentOffset {
            headerConstraint.deactivate()
            headerView.snp.makeConstraints { make in
                headerConstraint = make.height.equalTo(view.snp.width).multipliedBy(0.65).offset(-yOffset / 2).constraint
            }
            headerView.alpha = (180 - yOffset) / 180
            headerView.isHidden = yOffset >= 180
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.tracks.count - 10 {
            viewModel.fetchNext()
        }
    }
}
