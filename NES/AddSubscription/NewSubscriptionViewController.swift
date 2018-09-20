//
//  NewSubscriptionViewController.swift
//  NES
//
//  Created by Andrew Robinson on 9/19/18.
//  Copyright © 2018 XYello, Inc. All rights reserved.
//

import UIKit

class NewSubscriptionViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var createButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))

        containerView.backgroundColor = .black
        containerView.roundCorners(radius: 10.0)

        titleTextField.textColor = .white
        titleTextField.attributedPlaceholder = NSAttributedString(string: "Subscription Title", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)])

        createButton.setTitle("Create Subscription", for: .normal)
    }

    // MARK: - Actions

    @IBAction func createButtonPressed(_ sender: UIButton) {
        if let name = titleTextField.text {
            let new = Subscription.init(name: name)
            SubscriptionManager.instance.addSubscription(subscription: new)
            dismiss(animated: true, completion: nil)
        } else {
        }
    }

    @objc private func cancel() {
        dismiss(animated: true, completion: nil)
    }

}
