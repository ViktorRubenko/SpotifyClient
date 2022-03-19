//
//  ArtistViewController.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 18.03.2022.
//

import UIKit
import SnapKit

class ArtistViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createLayout())
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
    
    private lazy var artistImageBackground: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var viewModel: ArtistViewModel!
    private let gradientBackgroundView = GradientBackgroundView()
    private var previousNavigationBarAppearance: UINavigationBarAppearance?
    private var needSetOffset = true
    private var topContentOffset = 0.0
    private var backgroundOffset: Double {
        topContentOffset * 1.5
    }
    private var backgroundBottomContraint: Constraint!
    
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
    
    override func viewWillLayoutSubviews() {
        if needSetOffset {
            needSetOffset = false
            topContentOffset = view.bounds.height * 0.3 > 250 ? view.bounds.height * 0.3 : 250
            collectionView.contentInset = UIEdgeInsets(top: topContentOffset, left: 0, bottom: 0, right: 0)
        }
    }
}
// MARK: - Methods
extension ArtistViewController {
    private func setupNavigationBar() {
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
        view.backgroundColor = .systemBackground
        
        view.addSubview(gradientBackgroundView)
        gradientBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(artistImageBackground)
        artistImageBackground.snp.makeConstraints { make in
            make.top.equalToSuperview()
            backgroundBottomContraint = make.bottom.equalTo(view.snp.centerY).constraint
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        view.addSubview(collectionView)
        collectionView.backgroundColor = .clear
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
        viewModel.artistImage.bind { [weak self] image in
            self?.artistImageBackground.image = image
            self?.gradientBackgroundView.setStartColor(image?.averageColor)
        }
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { section, _ in
            self.createSection(section)
        }
        layout.register(SectionBackgroundView.self, forDecorationViewOfKind: SectionBackgroundView.id)
        return layout
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
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)),
                subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [
                NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50)),
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top)]
            section.interGroupSpacing = 2
            
            section.decorationItems = [
                NSCollectionLayoutDecorationItem.background(elementKind: SectionBackgroundView.id)
            ]
            
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        var topBarHeight: CGFloat {
            return ((view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
                    (self.navigationController?.navigationBar.frame.height ?? 0.0))
        }
        let fixedDownOffset = topBarHeight - yOffset
        if fixedDownOffset >= view.center.y {
            backgroundBottomContraint.deactivate()
            artistImageBackground.snp.makeConstraints { make in
                backgroundBottomContraint = make.bottom.equalTo(view.snp.centerY).offset(fixedDownOffset - view.center.y).constraint
            }
        }

        let fixedTopOffset = yOffset + topContentOffset
        if fixedTopOffset >= 0 {
            artistImageBackground.alpha = (topContentOffset * 0.7 - fixedTopOffset) / (topContentOffset * 0.7)
        }
    }
}
