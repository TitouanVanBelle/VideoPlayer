//
//  CALayer+Animation.swift
//  
//
//  Created by Titouan Van Belle on 23.09.20.
//

import Foundation
import QuartzCore

extension CALayer {
    func resizeAndMove(frame: CGRect, duration: TimeInterval = 0.3) {
        let positionAnimation = CABasicAnimation(keyPath: "position")
        positionAnimation.fromValue = value(forKey: "position")
        positionAnimation.toValue = NSValue(cgPoint: CGPoint(x: frame.minX, y: frame.minY))

        let oldBounds = bounds
        var newBounds = oldBounds
        newBounds.size = frame.size

        let boundsAnimation = CABasicAnimation(keyPath: "bounds")
        boundsAnimation.fromValue = NSValue(cgRect: oldBounds)
        boundsAnimation.toValue = NSValue(cgRect: newBounds)

        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [positionAnimation, boundsAnimation]
        groupAnimation.fillMode = .forwards
        groupAnimation.duration = duration
        groupAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        self.frame = frame
        add(groupAnimation, forKey: "frame")
    }
}
