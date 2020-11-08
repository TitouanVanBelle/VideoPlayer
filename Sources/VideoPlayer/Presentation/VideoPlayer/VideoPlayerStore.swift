//
//  VideoPlayerStore.swift
//  
//
//  Created by Titouan Van Belle on 28.10.20.
//

import AVFoundation
import Foundation
import Combine

final class VideoPlayerStore {

    // MARK: Public Properties

    @Published var playheadProgress: CMTime = .zero

    @Published var isPlaying: Bool = false

    lazy var itemDidPlayToEnd: AnyPublisher<Void, Never> = {
        player.itemDidPlayToEnd
    }()

    var formattedCurrentTime: String {
        currentTimeInSeconds >= 3600 ?
            DateComponentsFormatter.longDurationFormatter.string(from: currentTimeInSeconds) ?? "" :
            DateComponentsFormatter.shortDurationFormatter.string(from: currentTimeInSeconds) ?? ""
    }

    var formattedDuration: String {
        durationInSeconds >= 3600 ?
            DateComponentsFormatter.longDurationFormatter.string(from: durationInSeconds) ?? "" :
            DateComponentsFormatter.shortDurationFormatter.string(from: durationInSeconds) ?? ""
    }

    var shouldSeekBackToBeginning: Bool = false

    let player = AVPlayer()

    // MARK: Private Properties

    private var nextSeekingTime: CMTime?
    private var isSeeking: Bool = false

    private var cancellables = Set<AnyCancellable>()

    // MARK: Init

    init() {
        setupBindings()
    }
}

// MARK: Bindings

fileprivate extension VideoPlayerStore {
    func setupBindings() {
        player.progress()
            .assign(to: \.playheadProgress, weakly: self)
            .store(in: &cancellables)

        player.publisher(for: \.timeControlStatus)
            .map { $0 == .playing ? true : false }
            .assign(to: \.isPlaying, weakly: self)
            .store(in: &cancellables)

        player.itemDidPlayToEnd
            .map { true }
            .assign(to: \.shouldSeekBackToBeginning, weakly: self)
            .store(in: &cancellables)
    }
}

extension VideoPlayerStore {
    func load(_ item: AVPlayerItem) {
        player.replaceCurrentItem(with: item)

        if player.currentItem != nil {
            player.pause()
        }
    }

    func play() {
        if shouldSeekBackToBeginning {
            player.seekBackToBeginning()
            shouldSeekBackToBeginning = false
        }

        player.play()
    }

    func pause() {
        player.pause()
    }

    func seek(to time: CMTime) {
        guard !isSeeking else {
            nextSeekingTime = time
            return
        }

        isSeeking = true

        player.seek(to: time, toleranceBefore: .zero, toleranceAfter: .zero) { [weak self] finished in
            guard let self = self else { return }
            self.isSeeking = false

            if let nextSeekingTime = self.nextSeekingTime {
                self.nextSeekingTime = nil
                self.seek(to: nextSeekingTime)
            }
        }
    }

    func startTime(forFraction fraction: Double) -> CMTime {
        CMTime(seconds: duration.seconds * fraction, preferredTimescale: duration.timescale)
    }

    var progress: Double {
        guard durationInSeconds != .zero else {
            return .zero
        }

        return currentTimeInSeconds / durationInSeconds
    }
}

fileprivate extension VideoPlayerStore {
    var currentItem: AVPlayerItem? {
        player.currentItem
    }

    var duration: CMTime {
        guard let currentItem = currentItem else {
            return .zero
        }

        return currentItem.duration
    }

    var currentTime: CMTime {
        player.currentTime()
    }

    var currentTimeInSeconds: Double {
        guard !currentTime.seconds.isNaN else {
            return .zero
        }

        return currentTime.seconds
    }

    var durationInSeconds: Double {
        guard !duration.seconds.isNaN else {
            return .zero
        }

        return duration.seconds
    }
}
