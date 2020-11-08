//
//  ControlsView.swift
//  
//
//  Created by Titouan Van Belle on 24.09.20.
//

import UIKit

final class ControlsView: UIView {

    // MARK: Public Properties

    lazy var playButton: PlayPauseButton = makePlayButton()
    lazy var durationLabel: UILabel = makeDurationLabel()
    lazy var currentTimeLabel: UILabel = makeCurrentTimeLabel()
    lazy var fullscreenButton: UIButton = makeFullscreenButton()
    lazy var progressView: ProgressView = makeProgressView()

    var playButtonAction: (() -> Void)?
    var fullscreenButtonAction: (() -> Void)?

    // MARK: Private Properties

    private let isFullscreen: Bool
    private let capabilities: VideoPlayerController.Capabilities
    private let theme: VideoPlayerController.Theme

    init(
        capabilities: VideoPlayerController.Capabilities,
        theme: VideoPlayerController.Theme,
        isFullscreen: Bool
    ) {
        self.capabilities = capabilities
        self.theme = theme
        self.isFullscreen = isFullscreen

        super.init(frame: .zero)

        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: UI

fileprivate extension ControlsView {
    func setupUI() {
        setupView()
        setupConstraints()
    }

    func setupView() {
        if capabilities.contains(.playPause) {
            addSubview(playButton)
        }

        if capabilities.contains(.fullscreen) {
            addSubview(fullscreenButton)
        }

        if capabilities.contains(.seek) {
            addSubview(durationLabel)
            addSubview(currentTimeLabel)
            addSubview(progressView)
        }
    }

    func setupConstraints() {
        if capabilities.contains(.playPause) {
            playButton.autoSetDimension(.height, toSize: 88.0)
            playButton.autoSetDimension(.width, toSize: 88.0)
            playButton.autoCenterInSuperview()
        }

        if capabilities.contains(.fullscreen) {
            fullscreenButton.autoSetDimension(.height, toSize: 44.0)
            fullscreenButton.autoSetDimension(.width, toSize: 44.0)
            fullscreenButton.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 14.0)
            fullscreenButton.autoPinEdge(toSuperviewSafeArea: .right, withInset: 10.0)
        }

        if capabilities.contains(.seek) {
            progressView.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 10.0)
            progressView.autoPinEdge(toSuperviewEdge: .left, withInset: 26.0)
            progressView.autoSetDimension(.height, toSize: 34.0)

            currentTimeLabel.autoPinEdge(.left, to: .left, of: progressView)
            currentTimeLabel.autoPinEdge(.bottom, to: .top, of: progressView)

            durationLabel.autoPinEdge(.right, to: .right, of: progressView)
            durationLabel.autoPinEdge(.bottom, to: .top, of: progressView)
        }

        if capabilities.contains(.fullscreen) && capabilities.contains(.seek) {
            progressView.autoPinEdge(.right, to: .left, of: fullscreenButton, withOffset: -10.0)
        } else if capabilities.contains(.seek) {
            progressView.autoPinEdge(toSuperviewEdge: .right, withInset: 26.0)
        }

    }

    func makePlayButton() -> PlayPauseButton {
        let button = PlayPauseButton()
        button.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        button.imageEdgeInsets = UIEdgeInsets(top: 15, left: 16, bottom: 15, right: 16)
        button.tintColor = theme.controlsTintColor
        return button
    }

    func makeFullscreenButton() -> UIButton {
        let button = UIButton()
        let name = isFullscreen ? "ExitFullscreen" : "EnterFullscreen"
        let image = UIImage(named: name, in: .module, compatibleWith: nil)
        button.addTarget(self, action: #selector(fullscreenButtonTapped), for: .touchUpInside)
        button.setImage(image, for: .normal)
        button.tintColor = theme.controlsTintColor
        return button
    }

    func makeProgressView() -> ProgressView {
        let view = ProgressView(theme: theme)
        return view
    }

    func makeDurationLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13.0)
        label.text = "0:00"
        label.textColor = theme.controlsTintColor
        return label
    }

    func makeCurrentTimeLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13.0)
        label.text = "0:00"
        label.textColor = theme.controlsTintColor
        return label
    }
}

// MARK: Actions

fileprivate extension ControlsView {
    @objc func playButtonTapped() {
        playButtonAction?()
    }

    @objc func fullscreenButtonTapped() {
        fullscreenButtonAction?()
    }
}


public extension UIStackView {
    func setBackgroundColor(_ color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}
