//
//  UIViewController+Child.swift
//  
//
//  Created by Titouan Van Belle on 25.09.20.
//

import UIKit

extension UIViewController {
    func add(_ controller: UIViewController) {
        addChild(controller)
        view.addSubview(controller.view)
        controller.didMove(toParent: self)
    }
}
