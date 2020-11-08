//
//  VideoPlayerViewFactory.swift
//  
//
//  Created by Titouan Van Belle on 21.09.20.
//

import AVFoundation
import Foundation

protocol VideoPlayerViewFactoryProtocol {
    func makeFullscreenVideoPlayerController(
        store: VideoPlayerStore,
        capabilities: VideoPlayerController.Capabilities,
        theme: VideoPlayerController.Theme,
        originalFrame: CGRect?
    ) -> FullscreenVideoPlayerController

    func makeControlsViewController(
        store: VideoPlayerStore,
        capabilities: VideoPlayerController.Capabilities,
        theme: VideoPlayerController.Theme,
        isFullscreen: Bool
    ) -> ControlsViewController
}

final class VideoPlayerViewFactory: VideoPlayerViewFactoryProtocol {

    // MARK: Init

    func makeFullscreenVideoPlayerController(
        store: VideoPlayerStore,
        capabilities: VideoPlayerController.Capabilities,
        theme: VideoPlayerController.Theme,
        originalFrame: CGRect?
    ) -> FullscreenVideoPlayerController {
        FullscreenVideoPlayerController(
            store: store,
            viewFactory: self,
            capabilities: capabilities,
            theme: theme,
            originalFrame: originalFrame)
    }

    func makeControlsViewController(
        store: VideoPlayerStore,
        capabilities: VideoPlayerController.Capabilities,
        theme: VideoPlayerController.Theme,
        isFullscreen: Bool
    ) -> ControlsViewController {
        ControlsViewController(
            store: store,
            capabilities: capabilities,
            theme: theme,
            isFullscreen: isFullscreen)
    }
}
