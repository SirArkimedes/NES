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

    private var shouldDismissOnNextAppear = false

    override func viewDidLoad() {
        super.viewDidLoad()

        customButton.backgroundColor = .lightGray

        let v = createSafeAreaSpacerView()
        v.backgroundColor = .lightGray
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if shouldDismissOnNextAppear {
            dismiss(animated: false, completion: nil)
        }
    }

    // MARK: - Actions

    @IBAction func customButtonPressed(_ sender: UIButton) {
        let vc = NewSubscriptionViewController()
        let nvc = UINavigationController(rootViewController: vc)

        shouldDismissOnNextAppear = true
        present(nvc, animated: true, completion: nil)
    }

}
