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
    
    private let subColor: SubDefaultColors
    private let delegate: IconSelectorViewControllerDelegate
    private let subBackColor: UIColor
    private let currentlySetEmoji: String?

    private let emojiCategories = Smile.emojiCategories
    private var emojiInOrder = [String]()

    init(color: SubDefaultColors, currentlySetEmoji: String?, delegate: IconSelectorViewControllerDelegate) {
        subColor = color
        self.currentlySetEmoji = currentlySetEmoji
        self.delegate = delegate
        
        subBackColor = subColor == .black ? UIColor.lightGray.withAlphaComponent(0.5) : subColor.color.darker(negative: 30).withAlphaComponent(0.5)
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
        navigationItem.setRightBarButton(UIBarButtonItem(title: "Select", style: .done, target: self, action: #selector(done)), animated: true)

        view.backgroundColor = subColor.color

        emojiLabel.text = currentlySetEmoji ?? "❔"
        emojiLabel.roundCorners()
        emojiLabel.layer.borderWidth = 2.0
        emojiLabel.layer.borderColor = subBackColor.cgColor

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.register(UINib(nibName: String(describing: IconCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: IconCollectionViewCell.self))

        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).minimumInteritemSpacing = 5.0

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
    }

    // MARK: - Actions

    @objc private func done() {
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

        cell.backgroundColor = subBackColor
        cell.roundCorners(radius: 5.0)

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
