//
//  PlayerView.swift
//  
//
//  Created by Titouan Van Belle on 25.09.20.
//

import AVFoundation
import Foundation
import UIKit

final class PlayerView: UIView {
    var player: AVPlayer? {
        get { playerLayer.player }
        set { playerLayer.player = newValue }
    }

    var playerLayer: AVPlayerLayer {
        layer as! AVPlayerLayer
    }

    override static var layerClass: AnyClass {
        AVPlayerLayer.self
    }
}
