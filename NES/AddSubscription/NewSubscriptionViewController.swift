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

    @IBOutlet weak var costTextField: UITextField!

    @IBOutlet weak var occurenceSectionLabel: UILabel!
    @IBOutlet weak var occurenceChoiceLabel: UILabel!
    @IBOutlet weak var occurencePicker: UIPickerView!
    @IBOutlet weak var occurencePickerHeight: NSLayoutConstraint!

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

        costTextField.roundCorners(radius: 10.0)
        costTextField.backgroundColor = .clear
        costTextField.delegate = self

        occurenceChoiceLabel.text = "Every 1 month"
        occurencePicker.delegate = self
        occurencePicker.dataSource = self
        occurencePickerHeight.constant = 0.0

        setColors()
    }

    // MARK: - Actions

    @IBAction func createButtonPressed(_ sender: UIButton) {
        if let name = titleTextField.text, let costText = costTextField.text, name != "", costText != "", let cost = Double(costText) {
            let new = Subscription()
            new.name = name
            new.cost = cost
            new.colorRed = chosenSubColor.getRed()
            new.colorGreen = chosenSubColor.getGreen()
            new.colorBlue = chosenSubColor.getBlue()
            new.occurencePeriod = occurencePicker.selectedRow(inComponent: 0) + 1
            new.occurenceCycle = OccurenceCycle(rawValue: occurencePicker.selectedRow(inComponent: 1))!

            if let emoji = emojiLabel.text {
                new.emojiIcon = emoji
            }

            SubscriptionManager.instance.addSubscription(subscription: new)
            cancel()
        }
    }

    @objc private func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func iconButtonPressed(_ sender: UIButton) {
        openColorSelector(for: .emoji)
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
        openColorSelector(for: .color)
    }

    @IBAction func occurenceButtonPressed(_ sender: UIButton) {
        occurencePickerHeight.constant = 182.0
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }

    // MARK: - Helpers

    private func setColors() { // These are colors that can be animated.
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

        costTextField.attributedPlaceholder = NSAttributedString(string: "$0.00", attributes: [NSAttributedString.Key.foregroundColor: chosenColor.oppositeColorBasedOnBrightness().withAlphaComponent(0.5)])
        costTextField.textColor = chosenSubColor.color.oppositeColorBasedOnBrightness()

        occurenceChoiceLabel.textColor = chosenColor.oppositeColorBasedOnBrightness()
        occurenceSectionLabel.textColor = chosenColor.oppositeColorBasedOnBrightness()
        occurencePicker.reloadAllComponents()
    }

    private func openColorSelector(for choice: ColorSelectorViewController.Segment) {
        let selector = ColorSelectorViewController(color: chosenSubColor, displaySegment: choice)
        let back = ColorAndIconShowViewController(color: chosenSubColor, currentlySetEmoji: emojiLabel.text)
        let nvc = UINavigationController(rootViewController: back)

        selector.add(delegate: back)
        selector.add(delegate: self)

        let pulley = PulleyViewController(contentViewController: nvc, drawerViewController: selector)
        pulley.initialDrawerPosition = .partiallyRevealed

        present(pulley, animated: true, completion: nil)
    }

}

extension NewSubscriptionViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        // Can't have a period as first character...
        if (textField.text ?? "").isEmpty && string.contains(".") {
            return false
        }

        // Can't have repeating decimals. (Ex: "....")
        if string == "." && textField.text?.last == "." {
            return false
        }

        let newText = textField.text ?? "" + string
        let elements = newText.split(separator: ".")

        // Only two digts after decimal...
        if newText.contains(".") {
            if elements.count > 1 && elements[1].count > 1 && string != "" {
                return false
            }
        }

        // Check for 10 digits...
        if elements.count > 0 && elements[0].count > 10 && string != "" {
            return false
        }

        return true
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

extension NewSubscriptionViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 1 {
            return 3
        }

        return 30
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 1 {
            switch row {
            case 1:
                return "Year(s)"
            case 2:
                return "Day(s)"
            default:
                return "Month(s)"
            }
        }

        return "\(row + 1)"
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var title = "\(row + 1)"
        if component == 1 {
            switch row {
            case 1:
                title = "Year(s)"
            case 2:
                title = "Day(s)"
            default:
                title = "Month(s)"
            }
        }
        return NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor: chosenColor.oppositeColorBasedOnBrightness()])
    }
}

extension NewSubscriptionViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var builder = "Every \(pickerView.selectedRow(inComponent: 0) + 1) "
        switch pickerView.selectedRow(inComponent: 1) {
        case 1:
            builder += "year"
        case 2:
            builder += "day"
        default:
            builder += "month"
        }

        occurenceChoiceLabel.text = pickerView.selectedRow(inComponent: 0) == 0 ? builder : "\(builder)s"
    }
}
