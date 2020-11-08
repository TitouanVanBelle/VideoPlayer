//
//  AVPlayerConvenience.swift
//  
//
//  Created by Titouan Van Belle on 17.09.20.
//

import AVFoundation
import Foundation

extension AVPlayer {
    func seekBackToBeginning() {
        guard let currentItem = currentItem else { return }
        let time = CMTime(seconds: 0, preferredTimescale: currentItem.asset.duration.timescale)
        seek(to: time)
    }
}
