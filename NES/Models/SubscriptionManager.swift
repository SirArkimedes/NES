//
//  SubscriptionManager.swift
//  NES
//
//  Created by Andrew Robinson on 9/19/18.
//  Copyright © 2018 XYello, Inc. All rights reserved.
//

import RealmSwift
import CloudKit
import RxRealm
import RxSwift

class SubscriptionManager {
    typealias DidGetNewDataBlock = () -> ()
    static let instance = SubscriptionManager()

    private var subscriptions = [Subscription]()
    private let bag = DisposeBag()

    private let realm = try! Realm()

    func addSubscription(subscription: Subscription) {
        try! realm.write {
            realm.add(subscription)
        }
    }

    func getSubscriptionCount() -> Int {
        return subscriptions.count
    }

    func getSubscriptionAt(index: Int) -> Subscription {
        return subscriptions[index]
    }

    func getMonthlyCost() -> Double {
        var cost = 0.0
        for sub in subscriptions {
            switch sub.occurenceCycle {
            case .year:
                cost += sub.cost / (12.0 * Double(sub.occurencePeriod))
            case .month:
                cost += sub.cost / Double(sub.occurencePeriod)
            case .day:
                cost += sub.cost * (30 / Double(sub.occurencePeriod))
            }
        }
        return cost
    }

    func bind(with block: @escaping DidGetNewDataBlock) {
        let realm = try! Realm()
        let subscriptions = realm.objects(Subscription.self)

        Observable.array(from: subscriptions).subscribe(onNext: { (subscriptions) in
            self.subscriptions = subscriptions.filter{ !$0.isDeleted }
            block()
        }).disposed(by: bag)
    }
}
