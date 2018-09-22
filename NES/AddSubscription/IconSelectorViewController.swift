//
//  IconSelectorViewController.swift
//  NES
//
//  Created by Andrew Robinson on 9/21/18.
//  Copyright © 2018 XYello, Inc. All rights reserved.
//

import UIKit

protocol IconSelectorViewControllerDelegate {
    func didSelectIcon(icon: String)
    func didSelectEmoji(emoji: String)
}

class IconSelectorViewController: UIViewController {

    enum Side {
        case left
        case right
    }

    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    private let subColor: SubDefaultColors
    private var side = Side.left

    init(color: SubDefaultColors) {
        subColor = color
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Icon"

        navigationController?.navigationBar.barTintColor = subColor.color
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: subColor.color.oppositeColorBasedOnBrightness()]

        view.backgroundColor = subColor.color

        emojiLabel.text = "🍻"

        collectionView.dataSource = self
    }

}

extension IconSelectorViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
