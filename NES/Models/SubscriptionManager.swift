//
//  SubscriptionManager.swift
//  NES
//
//  Created by Andrew Robinson on 9/19/18.
//  Copyright © 2018 XYello, Inc. All rights reserved.
//

import RealmSwift
import CloudKit

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

    func bind() {
        let realm = try! Realm()

        /// Results instances are live, auto-updating views into the underlying data, which means results never have to be re-fetched.
        /// https://realm.io/docs/swift/latest/#objects-with-primary-keys
        let dogs = realm.objects(Subscription.self)

//        Observable.array(from: dogs).subscribe(onNext: { (dogs) in
//            /// When dogs data changes in Realm, the following code will be executed
//            /// It works like magic.
//            self.dogs = dogs.filter{ !$0.isDeleted }
//            self.tableView.reloadData()
//        }).disposed(by: bag)
    }
}
