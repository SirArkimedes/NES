//
//  ColorSelectorViewController.swift
//  NES
//
//  Created by Andrew Robinson on 9/23/18.
//  Copyright © 2018 XYello, Inc. All rights reserved.
//

import UIKit

protocol ColorSelectorViewControllerDelegate {
    func didSelect(color: SubDefaultColors)
}

class ColorSelectorViewController: UIViewController {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!

    private var subColor: SubDefaultColors

    private let colorsToChooseFrom = SubDefaultColors.array()

    private var delegates = [ColorSelectorViewControllerDelegate]()

    init(color: SubDefaultColors) {
        subColor = color
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")

        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).sectionInset = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.9, right: 16.0)
        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).minimumInteritemSpacing = 20.0

        setColors()
    }

    // MARK: - Actions

    @IBAction func segmentControlValueChanged(_ sender: UISegmentedControl) {
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
        return colorsToChooseFrom.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath)
        let color = colorsToChooseFrom[indexPath.row]

        cell.backgroundColor = color.color
        cell.roundCorners()
        cell.layer.borderWidth = 2.0
        cell.layer.borderColor = color == .white ? UIColor.lightGray.cgColor : UIColor.white.cgColor

        return cell
    }
}

extension ColorSelectorViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        subColor = colorsToChooseFrom[indexPath.row]

        UIView.animate(withDuration: 0.25) {
            self.setColors()
        }

        for delegate in delegates {
            delegate.didSelect(color: subColor)
        }
    }
}
