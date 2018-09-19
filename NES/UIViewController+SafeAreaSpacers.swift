//
//  UIViewController+SafeAreaSpacers.swift
//  NES
//
//  Created by Andrew Robinson on 9/18/18.
//  Copyright © 2018 XYello, Inc. All rights reserved.
//

import UIKit

extension UIViewController {
    func createSafeAreaSpacerView() -> UIView {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(v)

        v.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        v.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

        v.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        v.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        return v
    }
}
