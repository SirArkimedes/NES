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

enum SubDefaultColors {
    case red
    case blue
    case yellow
    case gray
    case salmon
    case orange
    case black
    case white

    // MARK: - Vars

    var color: UIColor {
        get {
            return UIColor(red: CGFloat(getRed())/255, green: CGFloat(getGreen())/255, blue: CGFloat(getBlue())/255, alpha: 1.0)
        }
    }

    // MARK: - Helpers
    func getRed() -> Int {
        switch self {
        case .red:
            return 254
        case .blue:
            return 42
        case .yellow:
            return 254
        case .gray:
            return 230
        case .salmon:
            return 254
        case .orange:
            return 243
        case .black:
            return 0
        case .white:
            return 255
        }
    }

    func getGreen() -> Int {
        switch self {
        case .red:
            return 74
        case .blue:
            return 183
        case .yellow:
            return 215
        case .gray:
            return 230
        case .salmon:
            return 138
        case .orange:
            return 119
        case .black:
            return 0
        case .white:
            return 255
        }
    }

    func getBlue() -> Int {
        switch self {
        case .red:
            return 73
        case .blue:
            return 202
        case .yellow:
            return 102
        case .gray:
            return 234
        case .salmon:
            return 113
        case .orange:
            return 54
        case .black:
            return 0
        case .white:
            return 255
        }
    }

    // MARK: - Statics

    static func array() -> [SubDefaultColors] {
        return [SubDefaultColors.red, SubDefaultColors.blue, SubDefaultColors.yellow,
                SubDefaultColors.gray, SubDefaultColors.salmon, SubDefaultColors.orange,
                SubDefaultColors.black, SubDefaultColors.white]
    }
}

class Subscription: Object {
    @objc dynamic var id = NSUUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var deleted = false

    @objc dynamic var colorRed = 255
    @objc dynamic var colorGreen = 255
    @objc dynamic var colorBlue = 255

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
