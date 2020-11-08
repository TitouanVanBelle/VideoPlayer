//
//  ViewController.swift
//  VideoPlayerDemo
//
//  Created by Titouan Van Belle on 24.09.20.
//

import AVFoundation
import Combine
import PureLayout
import UIKit
import VideoPlayer

final class ViewController: UIViewController {

    // MARK: Private Properties

    private lazy var videoPlayerController: VideoPlayerController = makeVideoPlayerController()

    private var cancellables = Set<AnyCancellable>()

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Video Player"

        setupUI()
        setupBindings()

        loadVideo()
    }
}

// MARK: Bindings

fileprivate extension ViewController {
    func setupBindings() {
        videoPlayerController.$currentTime.sink { currentTime in
            print("\(currentTime.seconds)")
        }.store(in: &cancellables)
    }
}

// MARK: UI

fileprivate extension ViewController {
    func setupUI() {
        setupView()
        setupConstraints()
    }

    func setupView() {
        add(videoPlayerController)
    }

    func setupConstraints() {
        videoPlayerController.view.autoPinEdge(toSuperviewSafeArea: .left)
        videoPlayerController.view.autoPinEdge(toSuperviewSafeArea: .right)
        videoPlayerController.view.autoPinEdge(toSuperviewEdge: .top)
        videoPlayerController.view.autoMatch(.height, to: .height, of: view, withMultiplier: 0.5)
    }

    func makeVideoPlayerController() -> VideoPlayerController {
        let capabilities: VideoPlayerController.Capabilities = [.seek, .fullscreen, .playPause]
        var theme = VideoPlayerController.Theme()
        theme.backgroundStyle = .plain(.white)
        theme.controlsTintColor = .white
        let controller = VideoPlayerController(capabilities: capabilities, theme: theme)
        controller.videoGravity = .resizeAspectFill
        return controller
    }
}

// MARK: Actions

fileprivate extension ViewController {
    func loadVideo() {
        let url = Bundle.main.url(forResource: "HongKong", withExtension: "mp4")!
        let item = AVPlayerItem(url: url)
        videoPlayerController.load(item: item, autoPlay: false)
    }
}


fileprivate extension UIViewController {
    func add(_ controller: UIViewController) {
        addChild(controller)
        view.addSubview(controller.view)
        controller.didMove(toParent: self)
    }
}
