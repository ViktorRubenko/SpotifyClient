//
//  SearchResultsViewController.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 15.03.2022.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func selectResultAt(indexPath: IndexPath, averageColor: UIColor?)
}

class SearchResultsViewController: UIViewController {

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(ItemListCell.self, forCellWithReuseIdentifier: ItemListCell.id)
        collectionView.register(NoResultsListCell.self, forCellWithReuseIdentifier: NoResultsListCell.id)
        collectionView.register(
            TextHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TextHeader.id)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private let viewModel: SearchViewModel!
    weak var delegate: SearchResultsViewControllerDelegate?
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        viewModel.resultSections.bind { [weak self] _ in
            self?.collectionView.reloadData()
        }
    }
}
// MARK: - Methods
extension SearchResultsViewController {
    private func setupViews() {
        view.backgroundColor = .red
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(55)),
            subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 2
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)]
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
// MARK: - UICollectionView Delegate/DataSource
extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        print(viewModel.resultSections.value.count)
        return viewModel.resultSections.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = viewModel.resultSections.value[section]
        return section.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = viewModel.resultSections.value[indexPath.section]
        let model = section.items[indexPath.row]
        switch model.itemType {
        case .noResults:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoResultsListCell.id, for: indexPath)
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemListCell.id, for: indexPath) as! ItemListCell
            cell.configure(model, useDefaultImage: true)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TextHeader.id,
            for: indexPath) as! TextHeader
        let section = viewModel.resultSections.value[indexPath.section]
        view.setTitle(section.title)
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ItemListCell
        delegate?.selectResultAt(indexPath: indexPath, averageColor: cell.averageColor)
    }
}
