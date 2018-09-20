//
//  SubscriptionManager.swift
//  NES
//
//  Created by Andrew Robinson on 9/19/18.
//  Copyright © 2018 XYello, Inc. All rights reserved.
//

import Foundation

class SubscriptionManager {
    static let instance = SubscriptionManager()

    private var subscriptions = [Subscription]()

    func addSubscription(subscription: Subscription) {
        subscriptions.append(subscription)
    }

    func getSubscriptionCount() -> Int {
        return subscriptions.count
    }

    func getSubscriptionAt(index: Int) -> Subscription {
        return subscriptions[index]
    }
}
