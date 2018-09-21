//
//  UIColor+Brightness.swift
//  NES
//
//  Created by Andrew Robinson on 9/20/18.
//  Copyright © 2018 XYello, Inc. All rights reserved.
//

import UIKit

enum ColorBrightness {
    case bright
    case dark
}

extension UIColor {
    func determineBrightness() -> ColorBrightness {
        let color = CIColor(color: self)
        if (color.red * 299 + color.green * 587 + color.blue * 114) / 1000 < 0.5 {
            return .dark
        } else {
            return .bright
        }
    }
}
