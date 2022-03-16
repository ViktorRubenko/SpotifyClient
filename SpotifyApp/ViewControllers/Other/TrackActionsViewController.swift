//
//  TrackActionsViewController.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 14.03.2022.
//

import UIKit

class TrackActionsViewController: UIViewController {
    
    private var viewModel: TrackActionsViewModel!
    private lazy var headerHeight = max(250.0, view.bounds.height / 3)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ImageTextHeader.self, forHeaderFooterViewReuseIdentifier: ImageTextHeader.id)
        return tableView
    }()
    
    private var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Close", for: .normal)
        return button
    }()
    
    private lazy var blurredBackgroundView: UIView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.view.bounds
        
        let alphaView = UIView()
        alphaView.backgroundColor = .black.withAlphaComponent(0.4)
        alphaView.frame = self.view.bounds
        
        let containerView = UIView()
        containerView.addSubview(blurView)
        containerView.addSubview(alphaView)
        
        return containerView
    }()

    init(viewModel: TrackActionsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
}
//MARK: - Methods
extension TrackActionsViewController {
    private func setupViews() {
        
        view.addSubview(blurredBackgroundView)
        view.sendSubviewToBack(blurredBackgroundView)
        
        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
        
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalTo(closeButton.snp.top)
        }
    }
}
//MARK: - Actions
extension TrackActionsViewController {
    @objc func didTapCloseButton() {
        dismiss(animated: true)
    }
}
//MARK: - TableView Delegate/DataSource
extension TrackActionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.trackActions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var contentConfig = cell.defaultContentConfiguration()
        contentConfig.text = viewModel.trackActions[indexPath.row].name
        cell.contentConfiguration = contentConfig
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        headerHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ImageTextHeader.id) as! ImageTextHeader
        header.configure(imageURL: viewModel.albumImageURL, topText: viewModel.topText, bottomText: viewModel.bottomText)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.trackActions[indexPath.row].callback()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -scrollView.bounds.height / 4 {
            dismiss(animated: true, completion: nil)
        }
    }
}

extension TrackActionsViewController: TrackActionsViewModelDelegate {
    
    func openAlbum(viewModel: AlbumViewModel) {
        let vc = TrackContainerViewController(viewModel: viewModel, containerType: .album)
        weak var pvc = self.presentingViewController
        dismiss(animated: true) {
            pvc?.present(vc, animated: true, completion: nil)
        }
    }
    
    func addToFavorites() {
        
    }
    
    func share(externalURL: String) {
        weak var pvc = self.presentingViewController
        let vc = UIActivityViewController(
            activityItems: [externalURL],
            applicationActivities: [])
        dismiss(animated: true) {
            pvc?.present(vc, animated: true, completion: nil)
        }
    }
    
    func showArtist() {
        
    }
}
