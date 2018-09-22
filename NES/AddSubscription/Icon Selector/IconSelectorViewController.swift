//
//  IconSelectorViewController.swift
//  NES
//
//  Created by Andrew Robinson on 9/21/18.
//  Copyright © 2018 XYello, Inc. All rights reserved.
//

import UIKit
import Smile

protocol IconSelectorViewControllerDelegate {
    func didSelectIcon(icon: String)
    func didSelectEmoji(emoji: String)
}

class IconSelectorViewController: UIViewController {

    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var doneButton: UIButton!
    
    private let subColor: SubDefaultColors
    private let delegate: IconSelectorViewControllerDelegate

    private let emojiCategories = Smile.emojiCategories
    private var emojiInOrder = [String]()

    init(color: SubDefaultColors, delegate: IconSelectorViewControllerDelegate) {
        subColor = color
        self.delegate = delegate
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
        emojiLabel.roundCorners()
        emojiLabel.layer.borderWidth = 2.0
        emojiLabel.layer.borderColor = subColor == .white ? UIColor.lightGray.cgColor : UIColor.white.cgColor

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.register(UINib(nibName: String(describing: IconCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: IconCollectionViewCell.self))

        // Put the emoji categories in order...
        emojiInOrder.append(contentsOf: emojiCategories["people"]!)
        emojiInOrder.append(contentsOf: emojiCategories["nature"]!)
        emojiInOrder.append(contentsOf: emojiCategories["foods"]!)
        emojiInOrder.append(contentsOf: emojiCategories["activity"]!)
        emojiInOrder.append(contentsOf: emojiCategories["places"]!)
        emojiInOrder.append(contentsOf: emojiCategories["objects"]!)
        emojiInOrder.append(contentsOf: emojiCategories["people"]!)
        emojiInOrder.append(contentsOf: emojiCategories["symbols"]!)
        emojiInOrder.append(contentsOf: emojiCategories["flags"]!)

        let v = createSafeAreaSpacerView()
        v.backgroundColor = subColor.color

        doneButton.backgroundColor = subColor.color
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(subColor.color.oppositeColorBasedOnBrightness(), for: .normal)
    }

    @IBAction func doneButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension IconSelectorViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojiInOrder.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: IconCollectionViewCell.self), for: indexPath) as! IconCollectionViewCell
        cell.label.text = emojiInOrder[indexPath.row]
        return cell
    }
}

extension IconSelectorViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let emoji = emojiInOrder[indexPath.row]
        emojiLabel.text = emoji
        delegate.didSelectEmoji(emoji: emoji)
    }
}
