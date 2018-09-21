//
//  UIColorExtensions.swift
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
    // MARK: - Brightness

    func determineBrightness() -> ColorBrightness {
        let color = CIColor(color: self)
        if (color.red * 299 + color.green * 587 + color.blue * 114) / 1000 < 0.5 {
            return .dark
        } else {
            return .bright
        }
    }

    // MARK: - Color from RGB Int

    static func color(red: Int, green: Int, blue: Int) -> UIColor {
        return UIColor(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: 1.0)
    }
}
