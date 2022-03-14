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
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            TrackViewCell.self,
            forCellWithReuseIdentifier: TrackViewCell.id)
        collectionView.register(
            AlbumHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: AlbumHeaderView.id)
        return collectionView
    }()
    private var headerView = ImageHeaderView()
    private var collectionViewTopInset = 260.0
    private var backgroundGradientView: UIView!
    private var albumAverageColor: UIColor?
    private var previousNavigatioBaraAppearance: UINavigationBarAppearance?
    
    init(id: String, albumAverageColor: UIColor?) {
        self.viewModel = AlbumViewModel(id: id)
        self.albumAverageColor = albumAverageColor
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        changeBackgroundGradient()
        setupNavigationBar()
        setupBinders()
        
        print("fetch")
        viewModel.fetch()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let appearance = previousNavigatioBaraAppearance else { return }
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
//MARK: - Methods
extension AlbumViewController {
    private func setupViews() {
        
        view.backgroundColor = .systemBackground
        
        let safeArea = view.safeAreaLayoutGuide
        
        backgroundGradientView = UIView()
        view.addSubview(backgroundGradientView)
        backgroundGradientView.snp.makeConstraints { make in
            make.top.equalTo(safeArea)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }

        view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.equalTo(safeArea.snp.top)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: collectionViewTopInset, left: 0, bottom: 0, right: 0)
        
    }
    
    private func changeBackgroundGradient() {
        guard let averageColor = albumAverageColor else { return }
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [averageColor.cgColor, UIColor.clear.cgColor]
        gradientLayer.shouldRasterize = true
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.7)
        backgroundGradientView.layer.addSublayer(gradientLayer)
    }
    
    private func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        title = ""
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward.circle"),
            style: .done,
            target: self,
            action: #selector(didTapBackButton))
        
        previousNavigatioBaraAppearance = navigationController?.navigationBar.standardAppearance
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = albumAverageColor
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
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
        switch indexPath.section {
            
        default:
            let model = viewModel.album.value.tracks[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackViewCell.id, for: indexPath) as! TrackViewCell
            cell.configure(model)
            cell.accessotyHandler = { [weak self] in
                let vc = TrackActionsViewController(id: model.id, fromAlbum: true)
                vc.modalPresentationStyle = .overFullScreen
                self?.present(vc, animated: true)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        default:
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: AlbumHeaderView.id,
                for: indexPath) as! AlbumHeaderView
            headerView.configure(viewModel.albumHeader)
            return headerView
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y + 91 + collectionViewTopInset
        title = yOffset <= collectionViewTopInset ? "" : viewModel.album.value.name
        headerView.scroll(yOffset)
    }
}
