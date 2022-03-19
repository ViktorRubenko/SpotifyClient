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
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 60, weight: .bold)
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private var viewModel: ArtistViewModel!
    private let gradientBackgroundView = GradientBackgroundView()
    private let reverseGradientView: GradientBackgroundView = {
        let view = GradientBackgroundView()
        view.reverse = true
        view.style = .medium
        view.setStartColor(.black)
        return view
    }()
    private var previousNavigationBarAppearance: UINavigationBarAppearance?
    private var needSetOffset = true
    private var topContentOffset = 0.0
    private var backgroundOffset: Double {
        topContentOffset * 1.5
    }
    private var backgroundBottomContraint: Constraint!
    private var nameLabelBottomConstraint: Constraint!
    private let reverseGradientAlpha = 0.33
    
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
            
            nameLabelBottomConstraint.deactivate()
            nameLabel.snp.makeConstraints { make in
                nameLabelBottomConstraint = make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(topContentOffset).constraint
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.scrollEdgeAppearance = previousNavigationBarAppearance
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
        
        collectionView.addSubview(reverseGradientView)
        reverseGradientView.alpha = reverseGradientAlpha
        collectionView.addSubview(nameLabel)
        
        reverseGradientView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.bottom.equalTo(nameLabel)
            make.top.equalTo(nameLabel)
        }
        nameLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
            nameLabelBottomConstraint = make.bottom.equalTo(view.snp.centerY).constraint
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
        viewModel.name.bind { [weak self] name in
            self?.nameLabel.text = name
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
        case .releases:
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)))
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(70)),
                subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [
                NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50)),
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top)]
            section.interGroupSpacing = 5
            
            section.decorationItems = [
                NSCollectionLayoutDecorationItem.background(elementKind: SectionBackgroundView.id)
            ]
            
            return section
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
        switch model.itemType {
        case .track:
            cell.configure(model, index: String(indexPath.row + 1))
            cell.accessoryHandler = { [weak self] in
                let vc = TrackActionsViewController(
                    viewModel: self!.viewModel.createTrackActionsViewModel(index: indexPath.row),
                    averageColor: cell.averageColor)
                vc.modalPresentationStyle = .overFullScreen
                self?.present(vc, animated: true)
            }
        case .album:
            cell.setFontSize(nameSize: 16, infoSize: 14)
            fallthrough
        default:
            cell.configure(model, withAccessory: false)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        let model = viewModel.sections.value[indexPath.section].items[indexPath.row]
        switch model.itemType {
        case .album:
            let averageColor = (collectionView.cellForItem(at: indexPath) as? AverageColorProtocol)?.averageColor
            let vc = TrackContainerViewController(
                viewModel: AlbumViewModel(id: model.id),
                containerType: .album,
                imageAverageColor: averageColor)
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
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
        
        title = -yOffset <= topContentOffset * 0.10 ? viewModel.name.value : ""
        
        nameLabelBottomConstraint.deactivate()
        nameLabel.snp.makeConstraints { make in
            nameLabelBottomConstraint = make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(-yOffset).constraint
        }
        
        let fixedDownOffset = topBarHeight - yOffset
        if fixedDownOffset >= view.center.y {
            backgroundBottomContraint.deactivate()
            artistImageBackground.snp.makeConstraints { make in
                backgroundBottomContraint = make.bottom.equalTo(view.snp.centerY).offset(fixedDownOffset - view.center.y).constraint
            }
        }
        
        let normalizedTopOffset = yOffset + topContentOffset
        if normalizedTopOffset >= 0 {
            reverseGradientView.alpha = reverseGradientAlpha * (topContentOffset - normalizedTopOffset * 1.5) / topContentOffset
            artistImageBackground.alpha = (topContentOffset - normalizedTopOffset * 1.85) / topContentOffset
        }
    }
}
