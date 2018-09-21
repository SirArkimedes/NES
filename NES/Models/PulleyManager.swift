//
//  PulleyManager.swift
//  NES
//
//  Created by Andrew Robinson on 9/20/18.
//  Copyright © 2018 XYello, Inc. All rights reserved.
//

import Foundation
import Pulley

class PulleyManager {
    static let instance = PulleyManager()

    private(set) var pulleyViewController: PulleyViewController!

    func createPulleyViewController() -> PulleyViewController {
        let vc = SubscriptionListViewController()
        let nvc = UINavigationController(rootViewController: vc)

        pulleyViewController = PulleyViewController(contentViewController: nvc, drawerViewController: AddSubListViewController())
        pulleyViewController.initialDrawerPosition = .closed
        return pulleyViewController
    }

    func set(drawerPosition: PulleyPosition, animated: Bool? = true) {
        pulleyViewController.setDrawerPosition(position: drawerPosition, animated: animated ?? true)
    }
}
