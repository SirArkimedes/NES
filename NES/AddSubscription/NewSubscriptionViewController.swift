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

    @IBOutlet weak var leftColorButton: UIButton!
    @IBOutlet weak var middleColorButton: UIButton!
    @IBOutlet weak var rightColorButton: UIButton!

    @IBOutlet weak var iconButton: UIButton!
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var emojiLabel: UILabel!

    @IBOutlet weak var moreColorsView: UIView!
    @IBOutlet weak var moreColorsButton: UIButton!

    private var chosenSubColor: SubDefaultColors = .white {
        didSet {
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

    private let colorsToChooseFrom = SubDefaultColors.array()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .done, target: self, action: #selector(createButtonPressed(_:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))

        title = "New Subscription"

        contentView.backgroundColor = .clear

        iconButton.roundCorners()
        iconButton.layer.borderWidth = 2.0
        iconButton.backgroundColor = .white
        iconLabel.textColor = .lightGray
        emojiLabel.text = nil

        leftColorButton.roundCorners()
        leftColorButton.setTitle("", for: .normal)
        leftColorButton.backgroundColor = SubDefaultColors.red.color
        leftColorButton.layer.borderWidth = 2.0
        leftColorButton.layer.borderColor = UIColor.white.cgColor

        middleColorButton.roundCorners()
        middleColorButton.setTitle("", for: .normal)
        middleColorButton.backgroundColor = SubDefaultColors.green.color
        middleColorButton.layer.borderWidth = 2.0
        middleColorButton.layer.borderColor = UIColor.white.cgColor

        rightColorButton.roundCorners()
        rightColorButton.setTitle("", for: .normal)
        rightColorButton.backgroundColor = SubDefaultColors.blue.color
        rightColorButton.layer.borderWidth = 2.0
        rightColorButton.layer.borderColor = UIColor.white.cgColor

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

            if let emoji = emojiLabel.text {
                new.emojiIcon = emoji
            }

            SubscriptionManager.instance.addSubscription(subscription: new)
            cancel()
        } else {
        }
    }

    @objc private func cancel() {
        presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func iconButtonPressed(_ sender: UIButton) {
        let vc = IconSelectorViewController(color: chosenSubColor, currentlySetEmoji: emojiLabel.text, delegate: self)
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func leftColorButtonPressed(_ sender: UIButton) {
        chosenSubColor = .red
    }

    @IBAction func middleColorButtonPressed(_ sender: UIButton) {
        chosenSubColor = .green
    }

    @IBAction func rightColorButtonPressed(_ sender: UIButton) {
        chosenSubColor = .blue
    }
    
    @IBAction func moreColorsButtonPressed(_ sender: UIButton) {
    }

    // MARK: - Helpers

    private func setColors() { // This is colors that can be animated.
        navigationController?.navigationBar.barTintColor = chosenColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: chosenColor.oppositeColorBasedOnBrightness()]
        navigationItem.leftBarButtonItem?.tintColor = chosenColor.oppositeColorBasedOnBrightness()

        view.backgroundColor = chosenColor

        titleTextField.textColor = chosenColor.oppositeColorBasedOnBrightness()
        titleTextField.attributedPlaceholder = NSAttributedString(string: "Subscription Title", attributes: [NSAttributedString.Key.foregroundColor: chosenColor.oppositeColorBasedOnBrightness().withAlphaComponent(0.5)])

        iconButton.layer.borderColor = chosenSubColor == .gray ? UIColor.black.cgColor : UIColor.lightGray.cgColor

        moreColorsView.backgroundColor = chosenSubColor == .black ? UIColor.lightGray.withAlphaComponent(0.5) : chosenSubColor.color.darker(negative: 30).withAlphaComponent(0.5)
        moreColorsButton.setTitleColor(chosenSubColor.color.oppositeColorBasedOnBrightness(), for: .normal)
    }

}

extension NewSubscriptionViewController: IconSelectorViewControllerDelegate {
    func didSelectIcon(icon: String) {
        iconLabel.text = ""
    }

    func didSelectEmoji(emoji: String) {
        iconLabel.text = ""
        emojiLabel.text = emoji
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
