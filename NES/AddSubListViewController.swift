//
//  AddSubListViewController.swift
//  NES
//
//  Created by Andrew Robinson on 9/18/18.
//  Copyright © 2018 XYello, Inc. All rights reserved.
//

import UIKit

class AddSubListViewController: UIViewController {

    @IBOutlet weak var customButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        customButton.backgroundColor = .lightGray

        let v = createSafeAreaSpacerView()
        v.backgroundColor = .lightGray
    }

    // MARK: - Actions

    @IBAction func customButtonPressed(_ sender: UIButton) {
    }

}
