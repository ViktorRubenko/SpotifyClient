//
//  PlayerViewController.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 21.03.2022.
//

import UIKit
import LNPopupController

class PlayerViewController: UIViewController {
    
    var viewModel: PlayerViewModel!
    private lazy var playPopItemButton = UIBarButtonItem(
        image: UIImage(systemName: "play.fill"),
        style: .plain,
        target: self,
        action: #selector(didTapPlayButton))
    private lazy var pausePopItemButton = UIBarButtonItem(
        image: UIImage(systemName: "pause.fill"),
        style: .plain,
        target: self,
        action: #selector(didTapPlayButton))
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "music.note")
        imageView.backgroundColor = UIColor(named: "SubBGColor")!.withAlphaComponent(0.8)
        return imageView
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .lightGray
        return label
    }()
    private lazy var slider: UISlider = {
        let slider = UISlider()
        slider.setThumbImage(UIImage(systemName: "circle.fill"), for: .normal)
        slider.maximumValue = 1.0
        slider.minimumValue = 0.0
        slider.isContinuous = true
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        slider.addTarget(self, action: #selector(didTapSlider), for: .touchUpInside)
        return slider
    }()
    private let trackLengthLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    private let currentTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    private lazy var playButton: UIButton = {
        let button = UIButton()
        button.setImage(playButtonImage, for: .normal)
        button.addTarget(self, action: #selector(didTapPlayButton), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    private var playButtonImage: UIImage? {
        UIImage.largeSymbolImage(systemName: viewModel.playerState.value == .playing ? "pause.circle.fill" : "play.circle.fill")
    }
    private lazy var backwardButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.largeSymbolImage(systemName: "backward.end.fill", weight: .light), for: .normal)
        button.addTarget(self, action: #selector(didTapBackwardButton), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    private lazy var forwardButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.largeSymbolImage(systemName: "forward.end.fill", weight: .light), for: .normal)
        button.addTarget(self, action: #selector(didTapForwardButton), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    private let buttonStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    private let bottomToolbar: UIToolbar = {
        let toolbar = UIToolbar()
        let appearance = UIToolbarAppearance()
        appearance.configureWithTransparentBackground()
        toolbar.standardAppearance = appearance
        return toolbar
    }()
    private let containerView = UIView()
    let imageViewContainer = UIView()
    private let gradientBackgroundView: GradientBackgroundView = {
        let view = GradientBackgroundView()
        view.setStartColor(.clear)
        view.setEndColor(.black.withAlphaComponent(0.7))
        view.style = .hard
        return view
    }()
    private var swipeGestureRecognizerRight: UISwipeGestureRecognizer!
    private var swipeGestureRecognizerLeft: UISwipeGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popupPresentationContainer?.popupContentView.popupCloseButtonStyle = .round
        
        setupPopItem()
        setupViews()
        setupBinders()
        setupGestureRecognizers()
        
        viewModel.fetch()
    }
}
// MARK: - Methods
extension PlayerViewController {
    func setupViews() {
        let safeArea = view.safeAreaLayoutGuide
        view.backgroundColor = .systemBackground
        
        view.addSubview(gradientBackgroundView)
        gradientBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(containerView)
        
        containerView.addSubview(imageViewContainer)
        containerView.addSubview(nameLabel)
        containerView.addSubview(infoLabel)
        containerView.addSubview(bottomToolbar)
        containerView.addSubview(buttonStack)
        containerView.addSubview(slider)
        containerView.addSubview(trackLengthLabel)
        containerView.addSubview(currentTimeLabel)
        
        imageViewContainer.addSubview(imageView)
        
        let backwardButtonContainer = UIView()
        backwardButtonContainer.addSubview(backwardButton)
        buttonStack.addArrangedSubview(backwardButtonContainer)
        
        let playButtonContainer = UIView()
        playButtonContainer.addSubview(playButton)
        buttonStack.addArrangedSubview(playButtonContainer)
        
        let forwardButtonContainer = UIView()
        forwardButtonContainer.addSubview(forwardButton)
        buttonStack.addArrangedSubview(forwardButtonContainer)
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(safeArea)
            make.bottom.equalTo(safeArea)
            make.leading.equalTo(safeArea).offset(20)
            make.trailing.equalTo(safeArea).offset(-20)
        }
        
        bottomToolbar.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        buttonStack.snp.makeConstraints { make in
            make.bottom.equalTo(bottomToolbar.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
        
        playButton.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.7)
            make.width.equalTo(playButton.snp.height)
            make.center.equalToSuperview()
        }
        forwardButton.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.35)
            make.width.equalTo(forwardButton.snp.height)
            make.center.equalToSuperview()
        }
        backwardButton.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.35)
            make.width.equalTo(backwardButton.snp.height)
            make.center.equalToSuperview()
        }
        
        trackLengthLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.bottom.equalTo(buttonStack.snp.top)
        }
        
        currentTimeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.bottom.equalTo(buttonStack.snp.top)
        }
        
        slider.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalTo(trackLengthLabel.snp.top)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.bottom.equalTo(slider.snp.top).offset(-10)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.bottom.equalTo(infoLabel.snp.top).offset(-2)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        imageViewContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.bottom.equalTo(nameLabel.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
        }
        
    }
    
    func setupGestureRecognizers() {
        
        swipeGestureRecognizerRight = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe))
        swipeGestureRecognizerRight.direction = .right
        popupPresentationContainer?.popupBar.addGestureRecognizer(swipeGestureRecognizerRight)
        
        swipeGestureRecognizerLeft = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe))
        swipeGestureRecognizerLeft.direction = .left
        popupPresentationContainer?.popupBar.addGestureRecognizer(swipeGestureRecognizerLeft)
        
        popupPresentationContainer?.popupInteractionStyle = .none
    }
    
    private func setupPopItem() {
        popupItem.title = ""
        popupItem.subtitle = ""
        popupItem.image = UIImage(systemName: "music.note")
        popupItem.trailingBarButtonItems = [
            playPopItemButton
        ]
        popupItem.progress = 0.0
    }
    
    private func setupBinders() {
        viewModel.playerState.bind { [weak self] playerState in
            switch playerState {
            case .playing:
                self?.popupItem.trailingBarButtonItems = [
                    self!.pausePopItemButton
                ]
            case .paused, .stopped:
                self?.popupItem.trailingBarButtonItems = [
                    self!.playPopItemButton
                ]
            }
            self?.playButton.setImage(self?.playButtonImage, for: .normal)
        }
        
        viewModel.playerProgress.bind { [weak self] progress in
            self?.popupItem.progress = progress
            self?.slider.value = progress
        }
        
        viewModel.trackArtist.bind { [weak self] artist in
            self?.popupItem.subtitle = artist
            self?.infoLabel.text = artist
        }
        
        viewModel.trackTitle.bind { [weak self] trackTitle in
            self?.popupItem.title = trackTitle
            self?.nameLabel.text = trackTitle
        }
        
        viewModel.error.bind { [weak self] errorMessageModel in
            guard let errorMessageModel = errorMessageModel else { return }
            let alert = UIAlertController(title: errorMessageModel.title, message: errorMessageModel.message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self?.present(alert, animated: true, completion: nil)
        }
        
        viewModel.trackImage.bind { [weak self] image in
            self?.imageView.image = image
            self?.view.backgroundColor = image?.averageColor
            
            self?.popupItem.image = image
            self?.setupPopupItemColor(image?.averageColor?.withAlphaComponent(0.35))
        }
        
        viewModel.trackLenght.bind { [weak self] value in
            self?.trackLengthLabel.text = value
        }
        
        viewModel.currentTime.bind{ [weak self] value in
            self?.currentTimeLabel.text = value
        }
    }
    
    private func setupPopupItemColor(_ color: UIColor?) {
        let popupAppearance = LNPopupBarAppearance()
        popupAppearance.backgroundColor = color
        popupPresentationContainer?.popupBar.standardAppearance = popupAppearance
        popupBar.barStyle = .prominent
    }
}
// MARK: - Actions
extension PlayerViewController {
    @objc private func didTapPlayButton() {
        switch viewModel.playerState.value {
        case .playing:
            viewModel.pausePlaying()
        default:
            viewModel.startPlaying()
        }
    }
    
    @objc private func didTapBackwardButton() {
        imageView.image = UIImage(systemName: "music.note")
        viewModel.playPrevious()
    }
    
    @objc private func didTapForwardButton() {
        imageView.image = UIImage(systemName: "music.note")
        viewModel.playNext()
    }
    
    @objc private func didSwipe(_ swipeGestureRecognizer: UISwipeGestureRecognizer) {
        switch swipeGestureRecognizer.direction {
        case .left:
            print("left")
            viewModel.playNext()
        case .right:
            print("right")
            viewModel.playPrevious()
        default:
            break
        }
    }
    
    @objc private func sliderValueChanged(_ slider: UISlider) {
        viewModel.sliderChanged(slider.value)
    }
    
    @objc private func didTapSlider() {
        viewModel.tapSlider()
    }
}
