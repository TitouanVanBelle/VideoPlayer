//
//  PlayPauseButton.swift
//  
//
//  Created by Titouan Van Belle on 16.09.20.
//

import UIKit

public final class PlayPauseButton: UIButton {

    public var isPaused: Bool = true {
        didSet {
            updateImage()
        }
    }

    public init() {
        super.init(frame: .zero)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        setImage(UIImage(named: "Play", in: .module, compatibleWith: nil), for: .normal)
        setImage(UIImage(named: "Pause", in: .module, compatibleWith: nil), for: .selected)
    }

    func updateImage() {
        isSelected = !isPaused
    }
}
