//
//  NewSubscriptionViewController.swift
//  NES
//
//  Created by Andrew Robinson on 9/19/18.
//  Copyright © 2018 XYello, Inc. All rights reserved.
//

import UIKit

class NewSubscriptionViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var colorCollectionView: UICollectionView!

    private var chosenSubColor: SubDefaultColors = .black {
        didSet {
            let brightness = chosenColor.determineBrightness()
            chosenBrightness = brightness

            switch brightness {
            case .dark:
                oppositeBrightnessColor = .white
            case .bright:
                oppositeBrightnessColor = .black
            }

            UIView.animate(withDuration: 0.25) {
                self.setColors()
            }
        }
    }
    private var chosenColor: UIColor {
        get {
            return chosenSubColor.color
        }
    }
    private var chosenBrightness = ColorBrightness.dark
    private var oppositeBrightnessColor = UIColor.white

    private let colorsToChooseFrom = SubDefaultColors.array()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .done, target: self, action: #selector(createButtonPressed(_:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        navigationItem.leftBarButtonItem?.tintColor = .red

        title = "New Subscription"

        contentView.backgroundColor = .clear

        colorCollectionView.dataSource = self
        colorCollectionView.delegate = self
        colorCollectionView.backgroundColor = .clear
        colorCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "colorCollectionCell")

        (colorCollectionView.collectionViewLayout as! UICollectionViewFlowLayout).sectionInset = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.9, right: 16.0)
        (colorCollectionView.collectionViewLayout as! UICollectionViewFlowLayout).minimumInteritemSpacing = 20.0

        setColors()
    }

    // MARK: - Actions

    @IBAction func createButtonPressed(_ sender: UIButton) {
        if let name = titleTextField.text, name != "" {
            let new = Subscription()
            new.name = name
            new.colorRed = chosenSubColor.getRed()
            new.colorGreen = chosenSubColor.getGreen()
            new.colorBlue = chosenSubColor.getBlue()

            SubscriptionManager.instance.addSubscription(subscription: new)
            cancel()
        } else {
        }
    }

    @objc private func cancel() {
        presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    // MARK: - Helpers

    private func setColors() { // This is colors that can be animated.
        navigationController?.navigationBar.barTintColor = chosenColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: oppositeBrightnessColor]

        view.backgroundColor = chosenColor

        titleTextField.textColor = oppositeBrightnessColor
        titleTextField.attributedPlaceholder = NSAttributedString(string: "Subscription Title", attributes: [NSAttributedString.Key.foregroundColor: oppositeBrightnessColor.withAlphaComponent(0.5)])
    }

}

extension NewSubscriptionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorsToChooseFrom.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCollectionCell", for: indexPath)
        let color = colorsToChooseFrom[indexPath.row]

        cell.backgroundColor = color.color
        cell.roundCorners()
        cell.layer.borderWidth = 2.0
        cell.layer.borderColor = color == .white ? UIColor.lightGray.cgColor : UIColor.white.cgColor

        return cell
    }
}

extension NewSubscriptionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        chosenSubColor = colorsToChooseFrom[indexPath.row]
    }
}
