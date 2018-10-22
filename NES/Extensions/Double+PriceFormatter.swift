//
//  Double+PriceFormatter.swift
//  NES
//
//  Created by Andrew Robinson on 10/21/18.
//  Copyright © 2018 XYello, Inc. All rights reserved.
//

import Foundation

extension Double {
    func displayedAsCurrency() -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let currency = formatter.string(from: self as NSNumber) {
            return currency
        }

        return nil
    }
}
