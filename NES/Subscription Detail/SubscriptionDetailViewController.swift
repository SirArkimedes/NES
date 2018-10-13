//
//  SubscriptionDetailViewController.swift
//  NES
//
//  Created by Andrew Robinson on 10/13/18.
//  Copyright © 2018 XYello, Inc. All rights reserved.
//

import UIKit

class SubscriptionDetailViewController: UIViewController {

    private let subscription: Subscription

    init(subscription: Subscription) {
        self.subscription = subscription
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let chosenColor = UIColor.subscription(subscription)

        if let emojiString = subscription.emojiIcon {
            title = "\(emojiString) \(subscription.name)"
        } else {
            title = subscription.name
        }
        view.backgroundColor = chosenColor

        navigationController?.navigationBar.barTintColor = chosenColor
        navigationController?.navigationBar.tintColor = chosenColor.oppositeColorBasedOnBrightness()
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: chosenColor.oppositeColorBasedOnBrightness()]
    }

    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        let chosenColor = UIColor.white
        navigationController?.navigationBar.barTintColor = chosenColor
        navigationController?.navigationBar.tintColor = chosenColor.oppositeColorBasedOnBrightness()
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: chosenColor.oppositeColorBasedOnBrightness()]
    }
}
