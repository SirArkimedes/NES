//
//  ColorSelectorViewController.swift
//  NES
//
//  Created by Andrew Robinson on 9/23/18.
//  Copyright © 2018 XYello, Inc. All rights reserved.
//

import UIKit
import Smile

protocol ColorSelectorViewControllerDelegate {
    func didSelect(color: SubDefaultColors)
    func didSelect(emoji: String)
}

class ColorSelectorViewController: UIViewController {

    enum Segment {
        case color
        case emoji
        case icon
    }
    
    @IBOutlet weak var grabView: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!

    private var subColor: SubDefaultColors
    private let colorsToChooseFrom = SubDefaultColors.array()
    private var currentlySelectedSegment = Segment.color

    private var delegates = [ColorSelectorViewControllerDelegate]()

    private let emojiCategories = Smile.emojiCategories
    private var emojiInOrder = [String]()

    init(color: SubDefaultColors) {
        subColor = color
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        grabView.roundCorners()
        grabView.backgroundColor = subColor.color.oppositeColorBasedOnBrightness().withAlphaComponent(0.5)

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "colorCollectionCell")
        collectionView.register(UINib(nibName: String(describing: IconCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: IconCollectionViewCell.self))

        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).sectionInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 42.0, right: 16.0)

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

        setColors()
    }

    // MARK: - Actions

    @IBAction func segmentControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            currentlySelectedSegment = .emoji
            (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).minimumInteritemSpacing = 5.0
        case 2:
            currentlySelectedSegment = .icon
        default:
            currentlySelectedSegment = .color
            (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).minimumInteritemSpacing = 20.0
        }

        collectionView.reloadData()
    }

    // MARK: - Helpers

    func add(delegate: ColorSelectorViewControllerDelegate) {
        delegates.append(delegate)
    }

    private func setColors() {
        view.backgroundColor = subColor.color
        segmentControl.tintColor = subColor.color.oppositeColorBasedOnBrightness()
        lineView.backgroundColor = subColor.color.oppositeColorBasedOnBrightness().withAlphaComponent(0.25)
    }

}

extension ColorSelectorViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch currentlySelectedSegment {
        case .color:
            return colorsToChooseFrom.count
        case .emoji:
            return emojiInOrder.count
        case .icon:
            return emojiInOrder.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch currentlySelectedSegment {
        case .color:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCollectionCell", for: indexPath)
            let color = colorsToChooseFrom[indexPath.row]

            cell.backgroundColor = color.color
            cell.roundCorners()
            cell.layer.borderWidth = 2.0
            cell.layer.borderColor = color == .white ? UIColor.lightGray.cgColor : UIColor.white.cgColor

            return cell
        case .emoji:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: IconCollectionViewCell.self), for: indexPath) as! IconCollectionViewCell
            cell.label.text = emojiInOrder[indexPath.row]

            cell.backgroundColor = subColor == .black ? UIColor.lightGray.withAlphaComponent(0.5) : subColor.color.darker(negative: 30).withAlphaComponent(0.5)
            cell.roundCorners(radius: 5.0)

            return cell
        case .icon:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCollectionCell", for: indexPath)
            let color = colorsToChooseFrom[indexPath.row]

            cell.backgroundColor = color.color
            cell.roundCorners()
            cell.layer.borderWidth = 2.0
            cell.layer.borderColor = color == .white ? UIColor.lightGray.cgColor : UIColor.white.cgColor

            return cell
        }
    }
}

extension ColorSelectorViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch currentlySelectedSegment {
        case .color:
            subColor = colorsToChooseFrom[indexPath.row]
            UIView.animate(withDuration: 0.25) {
                self.setColors()
            }

            for delegate in delegates {
                delegate.didSelect(color: subColor)
            }
        case .emoji:
            let emoji = emojiInOrder[indexPath.row]
            for delegate in delegates {
                delegate.didSelect(emoji: emoji)
            }
        case .icon:
            subColor = colorsToChooseFrom[indexPath.row]
            UIView.animate(withDuration: 0.25) {
                self.setColors()
            }

            for delegate in delegates {
                delegate.didSelect(color: subColor)
            }
        }
    }
}
