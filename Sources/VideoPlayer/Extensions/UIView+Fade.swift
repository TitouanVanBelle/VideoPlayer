//
//  UIView+Fade.swift
//  
//
//  Created by Titouan Van Belle on 26.10.20.
//

import Foundation
import UIKit

extension UIView {
    func fadeIn(_ duration: TimeInterval = 0.3) {
        self.isHidden = false
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: { _ in })
    }

    func fadeOut(_ duration: TimeInterval = 0.3) {
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: { _ in
            self.isHidden = true
        })
    }
}
