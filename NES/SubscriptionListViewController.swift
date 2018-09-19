//
//  SubscriptionListViewController.swift
//  NES
//
//  Created by Andrew Robinson on 9/18/18.
//  Copyright © 2018 XYello, Inc. All rights reserved.
//

import UIKit

class SubscriptionListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed)), animated: false)
    }

    // MARK: - Actions

    @objc private func addButtonPressed() {
    }

}
