//
//  ArtistViewController.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 18.03.2022.
//

import UIKit

class ArtistViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { section, _ in
                self.createSection(section)
            }))
        collectionView.register(
            ItemListCell.self,
            forCellWithReuseIdentifier: ItemListCell.id)
        collectionView.register(
            TextHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TextHeader.id)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    private var viewModel: ArtistViewModel!
    private var averageColor: UIColor?
    private var previousNavigationBarAppearance: UINavigationBarAppearance?
    
    init(id: String) {
        self.viewModel = ArtistViewModel(itemID: id)
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
}
// MARK: - Methods
extension ArtistViewController {
    private func setupNavigationBar() {
        title = ""
        navigationItem.largeTitleDisplayMode = .never
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 17, weight: .regular, scale: .large)
        let buttonImage = UIImage(systemName: "chevron.backward.circle", withConfiguration: imageConfig)
        
        let leftBarButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        leftBarButton.setImage(buttonImage, for: .normal)
        leftBarButton.layer.cornerRadius = 15
        leftBarButton.backgroundColor = .black.withAlphaComponent(0.5)
        leftBarButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarButton)
        
        previousNavigationBarAppearance = navigationController?.navigationBar.scrollEdgeAppearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupViews() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupBinders() {
        viewModel.sections.bind { [weak self] _ in
            self?.collectionView.reloadData()
        }
    }
    
    private func createSection(_ sectionIndex: Int) -> NSCollectionLayoutSection {
        let sectionType = viewModel.sections.value[sectionIndex].sectionType
        switch sectionType {
        default:
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)))
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(55)),
                subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [
                NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50)),
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top)]
            section.interGroupSpacing = 2
            return section
        }
    }
}
//MARK: - Actions
extension ArtistViewController {
    @objc func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}
//MARK: UICollectionView Delegate/DataSource
extension ArtistViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.sections.value.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.sections.value[section].items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = viewModel.sections.value[indexPath.section].items[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemListCell.id, for: indexPath) as! ItemListCell
        cell.configure(model, type: .track, index: String(indexPath.row + 1))
        cell.accessoryHandler = { [weak self] in
            let vc = TrackActionsViewController(
                viewModel: self!.viewModel.createTrackActionsViewModel(index: indexPath.row),
                averageColor: cell.averageColor)
            vc.modalPresentationStyle = .overFullScreen
            self?.present(vc, animated: true)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = viewModel.sections.value[indexPath.section]
        let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TextHeader.id,
            for: indexPath) as! TextHeader
        headerView.setTitle(section.title)
        return headerView
    }
}
