//
//  FullscreenVideoPlayerController.swift
//  
//
//  Created by Titouan Van Belle on 23.09.20.
//

import AVFoundation
import Combine
import PureLayout
import UIKit

final class FullscreenVideoPlayerController: UIViewController {

    // MARK: Private Properties

    private let animationDuration = 0.3

    private let originalFrame: CGRect?

    private lazy var scrollView: UIScrollView = makeScrollView()
    private lazy var playerView: PlayerView = makePlayView()
    private lazy var closeButton: UIButton = makeCloseButton()
    private lazy var controlsViewController: ControlsViewController = makeControlsViewController()

    private var cancellables = Set<AnyCancellable>()

    private weak var store: VideoPlayerStore!
    private let viewFactory: VideoPlayerViewFactoryProtocol
    private let capabilities: VideoPlayerController.Capabilities
    private let theme: VideoPlayerController.Theme

    // MARK: Init

    init(
        store: VideoPlayerStore,
        viewFactory: VideoPlayerViewFactoryProtocol,
        capabilities: VideoPlayerController.Capabilities,
        theme: VideoPlayerController.Theme,
        originalFrame: CGRect?
    ) {
        self.store = store
        self.viewFactory = viewFactory
        self.originalFrame = originalFrame
        self.theme = theme
        self.capabilities = capabilities

        super.init(nibName: nil, bundle: nil)

        modalPresentationStyle = .overFullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
//        setupBindings()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        animatePlayerLayerIn()
        animateBackgroundColorIn()
    }

    // MARK: Orientation

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate { context in
            self.playerView.frame = self.view.bounds
        }
    }
}

// MARK: Bindings

fileprivate extension FullscreenVideoPlayerController {
//    func setupBindings() {
//        store.state.player.itemDidPlayToEnd
//            .sink { [weak self] in
//                guard let self = self else { return }
//                self.itemDidPlayToEnd()
//            }
//            .store(in: &cancellables)
//    }
//
//    func itemDidPlayToEnd() {
//        store.send(event: .itemDidPlayToEnd)
//    }
}

// MARK: UI

fileprivate extension FullscreenVideoPlayerController {
    func setupUI() {
        setupView()
        setupConstraints()
    }

    func setupView() {
        view.backgroundColor = .clear

        view.addSubview(playerView)

        add(controlsViewController)

        if let originalFrame = originalFrame {
            playerView.frame = originalFrame
        }

        view.addSubview(closeButton)
    }

    func setupConstraints() {
        closeButton.autoSetDimension(.height, toSize: 48)
        closeButton.autoSetDimension(.width, toSize: 48)
        closeButton.autoPinEdge(toSuperviewSafeArea: .top, withInset: 4.0)
        closeButton.autoPinEdge(toSuperviewSafeArea: .right, withInset: 14.0)

        controlsViewController.view.autoPinEdgesToSuperviewEdges()
    }

    func animatePlayerLayerIn() {
        UIView.animate(withDuration: animationDuration) {
            self.playerView.frame = self.view.bounds
        }
    }

    func animatePlayerLayerOut() {
        UIView.animate(withDuration: animationDuration) {
            if let originalFrame = self.originalFrame {
                self.playerView.frame = originalFrame
            }
        }
    }

    func animateBackgroundColorIn() {
        UIView.animate(withDuration: animationDuration) {
            self.view.backgroundColor = .black
        }
    }

    func animateBackgroundColorOut() {
        UIView.animate(withDuration: animationDuration) {
            self.view.backgroundColor = .clear
        }
    }

    func makeScrollView() -> UIScrollView {
        let view = UIScrollView()
        return view
    }

    func makePlayView() -> PlayerView {
        let view = PlayerView()
        view.player = store.player
        return view
    }

    func makeCloseButton() -> UIButton {
        let button = UIButton()
        let image = UIImage(named: "Close", in: .module, compatibleWith: nil)
        button.setImage(image, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 12.0, left: 12.0, bottom: 12.0, right: 12.0)
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        return button
    }

    func makeControlsViewController() -> ControlsViewController {
        let controller = viewFactory.makeControlsViewController(
            store: store,
            capabilities: capabilities,
            theme: theme,
            isFullscreen: true
        )
        controller.delegate = self
        return controller
    }
}

// MARK: Actions

fileprivate extension FullscreenVideoPlayerController {
    @objc func close() {
        animatePlayerLayerOut()

        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
            self.dismiss(animated: false)
        }
    }
}

// MARK: Controls View Controller Delegate

extension FullscreenVideoPlayerController: ControlsViewControllerDelegate {
    func fullscreenButtonWasTapped() {
        close()
    }
}
