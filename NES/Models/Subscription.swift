//
//  Subscription.swift
//  NES
//
//  Created by Andrew Robinson on 9/19/18.
//  Copyright © 2018 XYello, Inc. All rights reserved.
//

import Foundation
import RealmSwift
import IceCream

class Subscription: Object {
    @objc dynamic var id = NSUUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var deleted = false

    override class func primaryKey() -> String? {
        return "id"
    }
}

// MARK: - CloudKit to Realm Database
extension Subscription: CKRecordConvertible {
    var isDeleted: Bool {
        return deleted
    }
}
extension Subscription: CKRecordRecoverable {
}
