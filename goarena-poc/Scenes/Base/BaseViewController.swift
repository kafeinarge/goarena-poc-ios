//
//  BaseViewController.swift
//  facelab
//
//  Created by serhat akalin on 6.09.2020.
//  Copyright © 2020 Lyrebird Studio. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension UINavigationController {
    func removeViewController(_ controller: UIViewController.Type) {
        if let viewController = viewControllers.first(where: { $0.isKind(of: controller.self) }) {
            viewController.removeFromParent()
        }
    }

    func popViewControllers(_ count: Int) {
        guard viewControllers.count > count else { return }
        popToViewController(viewControllers[viewControllers.count - count - 1], animated: true)
    }
}

