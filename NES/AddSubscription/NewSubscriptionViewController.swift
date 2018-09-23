//
//  NewSubscriptionViewController.swift
//  NES
//
//  Created by Andrew Robinson on 9/19/18.
//  Copyright © 2018 XYello, Inc. All rights reserved.
//

import UIKit
import Pulley

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

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(createButtonPressed(_:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))

        title = "New"

        contentView.backgroundColor = .clear

        iconButton.roundCorners()
        iconButton.layer.borderWidth = 2.0
        iconButton.backgroundColor = .white
        iconLabel.textColor = .lightGray
        emojiLabel.text = nil

        leftColorButton.roundCorners(radius: 10.0)
        leftColorButton.setTitle("", for: .normal)
        leftColorButton.backgroundColor = SubDefaultColors.red.color
        leftColorButton.layer.borderWidth = 2.0
        leftColorButton.layer.borderColor = UIColor.white.cgColor

        middleColorButton.roundCorners(radius: 10.0)
        middleColorButton.setTitle("", for: .normal)
        middleColorButton.backgroundColor = SubDefaultColors.green.color
        middleColorButton.layer.borderWidth = 2.0
        middleColorButton.layer.borderColor = UIColor.white.cgColor

        rightColorButton.roundCorners(radius: 10.0)
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
        let selector = ColorSelectorViewController(color: chosenSubColor)
        let back = ColorAndIconShowViewController(color: chosenSubColor, currentlySetEmoji: emojiLabel.text)
        let nvc = UINavigationController(rootViewController: back)

        selector.add(delegate: back)
        selector.add(delegate: self)

        let pulley = PulleyViewController(contentViewController: nvc, drawerViewController: selector)
        pulley.initialDrawerPosition = .partiallyRevealed

        present(pulley, animated: true, completion: nil)
    }

    // MARK: - Helpers

    private func setColors() { // This is colors that can be animated.
        navigationController?.navigationBar.barTintColor = chosenColor
        navigationController?.navigationBar.tintColor = chosenColor.oppositeColorBasedOnBrightness()
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

extension NewSubscriptionViewController: ColorSelectorViewControllerDelegate {
    func didSelect(color: SubDefaultColors) {
        chosenSubColor = color
        setColors()
    }

    func didSelect(emoji: String) {
        iconLabel.text = ""
        emojiLabel.text = emoji
    }
}
