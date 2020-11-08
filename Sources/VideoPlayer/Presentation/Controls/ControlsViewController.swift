//
//  ControlsViewController.swift
//  
//
//  Created by Titouan Van Belle on 25.09.20.
//

import Combine
import PureLayout
import UIKit

protocol ControlsViewControllerDelegate: class {
    func fullscreenButtonWasTapped()
}

final class ControlsViewController: UIViewController {

    // MARK: Public Properties

    weak var delegate: ControlsViewControllerDelegate?

    // MARK: Private Properties

    private var timer = Timer()

    private lazy var controlsView: ControlsView = makeControlsView()

    private var cancellables = Set<AnyCancellable>()

    private let store: VideoPlayerStore
    private let isFullscreen: Bool
    private let capabilities: VideoPlayerController.Capabilities
    private let theme: VideoPlayerController.Theme

    // MARK: Init

    init(
        store: VideoPlayerStore,
        capabilities: VideoPlayerController.Capabilities,
        theme: VideoPlayerController.Theme,
        isFullscreen: Bool
    ) {
        self.capabilities = capabilities
        self.isFullscreen = isFullscreen
        self.theme = theme
        self.store = store

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupBindings()
        setupGestureRecognizers()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        scheduleFadeOutTimer()
    }
}

// MARK: Timer

fileprivate extension ControlsViewController {
    func scheduleFadeOutTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: false, block: { _ in
            self.controlsView.fadeOut(0.1)
        })
    }

    func rescheduleFadeOutTimer() {
        timer.invalidate()
        scheduleFadeOutTimer()
    }
}

// MARK: Bindings

fileprivate extension ControlsViewController {
    func setupBindings() {
        store.$playheadProgress
            .filter { _ in self.store.isPlaying }
            .sink { [weak self] currentTime in
                guard let self = self else { return }

                self.controlsView.progressView.progress = self.store.progress
                self.controlsView.durationLabel.text = self.store.formattedDuration
                self.controlsView.currentTimeLabel.text = self.store.formattedCurrentTime
            }
            .store(in: &cancellables)

        store.$isPlaying
            .map { !$0 }
            .assign(to: \.isPaused, weakly: controlsView.playButton)
            .store(in: &cancellables)
    }
}


// MARK: Gestures

fileprivate extension ControlsViewController {
    func setupGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(playerTapped))
        tapGestureRecognizer.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGestureRecognizer)

        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(playerDoubleTapped(_:)))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTapGestureRecognizer)

        tapGestureRecognizer.require(toFail: doubleTapGestureRecognizer)
    }

    @objc func playerTapped() {
        if controlsView.isHidden {
            controlsView.fadeIn(0.1)
            scheduleFadeOutTimer()
        } else {
            timer.invalidate()
            controlsView.fadeOut(0.1)
        }
    }

    @objc func playerDoubleTapped(_ recognizer: UITapGestureRecognizer) {
        controlsView.fadeOut(0.1)

        let touchPoint = recognizer.location(in: view)

        /// - TODO: Implement Seek on double tap
    }
}

// MARK: UI

fileprivate extension ControlsViewController {
    func setupUI() {
        setupView()
        setupConstraints()
    }

    func setupView() {
        view.addSubview(controlsView)
    }

    func setupConstraints() {
        controlsView.autoPinEdgesToSuperviewSafeArea()
    }

    func makeControlsView() -> ControlsView {
        let view = ControlsView(
            capabilities: capabilities,
            theme: theme,
            isFullscreen: isFullscreen
        )
        view.fullscreenButtonAction = { [unowned self] in
            self.fullscreenButtonTapped()
        }
        view.playButtonAction = { [unowned self] in
            self.playButtonTapped()
        }

        return view
    }
}

// MARK: Actions

fileprivate extension ControlsViewController {
    func fullscreenButtonTapped() {
        delegate?.fullscreenButtonWasTapped()
    }

    func playButtonTapped() {
        rescheduleFadeOutTimer()

        if store.isPlaying {
            store.pause()
        } else {
            store.play()
        }
    }
}

