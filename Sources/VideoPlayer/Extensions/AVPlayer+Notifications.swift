//
//  AVPlayer+Publishers.swift
//  
//
//  Created by Titouan Van Belle on 21.09.20.
//

import AVFoundation
import Combine

extension AVPlayer {
    var itemDidPlayToEnd: AnyPublisher<Void, Never> {
        NotificationCenter.default
            .publisher(for: .AVPlayerItemDidPlayToEndTime)
            .map { _ in () }
            .eraseToAnyPublisher()
    }
}
