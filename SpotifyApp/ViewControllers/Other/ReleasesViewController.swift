//
//  ReleasesViewController.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 20.03.2022.
//

import UIKit

class ReleasesViewController: UIViewController {
    private let viewModel: ReleasesViewModel!
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ItemListCell.self, forCellWithReuseIdentifier: ItemListCell.id)
        return collectionView
    }()
    
    init(id: String) {
        viewModel = ReleasesViewModel(id: id)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavigationBar()
        setupBinders()
        
        viewModel.fetch()
    }
}
// MARK: - Methods
extension ReleasesViewController {
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupNavigationBar() {
        title = "Releases"
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func setupBinders() {
        viewModel.sections.bind { [weak self] _ in
            self?.collectionView.reloadData()
        }
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(100)),
            subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
// MARK: - UICollectionView Delegate/DataSource
extension ReleasesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.sections.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.sections.value[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = viewModel.sections.value[indexPath.section].items[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemListCell.id, for: indexPath) as! ItemListCell
        cell.configure(model, withAccessory: false)
        cell.setFontSize(nameSize: 17, infoSize: 14)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let averageColor = (collectionView.cellForItem(at: indexPath) as? AverageColorProtocol)?.averageColor
        let model = viewModel.sections.value[indexPath.section].items[indexPath.row]
        let vc = TrackContainerViewController(
            viewModel: AlbumViewModel(itemID: model.id),
            containerType: .album,
            imageAverageColor: averageColor)
        navigationController?.pushViewController(vc, animated: true)
    }
}
