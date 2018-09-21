//
//  NewSubscriptionViewController.swift
//  NES
//
//  Created by Andrew Robinson on 9/19/18.
//  Copyright © 2018 XYello, Inc. All rights reserved.
//

import UIKit

class NewSubscriptionViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!

    private var chosenColor = UIColor.black {
        didSet {
            let brightness = chosenColor.determineBrightness()
            chosenBrightness = brightness
            
            switch brightness {
            case .dark:
                oppositeBrightnessColor = .white
            case .bright:
                oppositeBrightnessColor = .black
            }
        }
    }
    private var chosenBrightness = ColorBrightness.dark
    private var oppositeBrightnessColor = UIColor.white

    override func viewDidLoad() {
        super.viewDidLoad()

        chosenColor = .black

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .done, target: self, action: #selector(createButtonPressed(_:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        navigationItem.leftBarButtonItem?.tintColor = .red

        title = "New Subscription"

        contentView.backgroundColor = .clear

        setColors()
    }

    // MARK: - Actions

    @IBAction func createButtonPressed(_ sender: UIButton) {
        if let name = titleTextField.text, name != "" {
            let new = Subscription()
            new.name = name

            SubscriptionManager.instance.addSubscription(subscription: new)
            cancel()
        } else {
        }
    }

    @objc private func cancel() {
        presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    // MARK: - Helpers

    private func setColors() {
        navigationController?.navigationBar.barTintColor = chosenColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: oppositeBrightnessColor]

        view.backgroundColor = chosenColor

        titleTextField.textColor = oppositeBrightnessColor
        titleTextField.attributedPlaceholder = NSAttributedString(string: "Subscription Title", attributes: [NSAttributedString.Key.foregroundColor: oppositeBrightnessColor.withAlphaComponent(0.5)])
    }

}
