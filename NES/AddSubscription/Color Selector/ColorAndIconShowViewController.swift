//
//  ColorAndIconShowViewController.swift
//  NES
//
//  Created by Andrew Robinson on 9/23/18.
//  Copyright © 2018 XYello, Inc. All rights reserved.
//

import UIKit

class ColorAndIconShowViewController: UIViewController {

    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var previewLabel: UILabel!
    @IBOutlet weak var previewEmojiLabel: UILabel!
    
    private var subColor: SubDefaultColors
    private let currentlySetEmoji: String?

    init(color: SubDefaultColors, currentlySetEmoji: String?) {
        subColor = color
        self.currentlySetEmoji = currentlySetEmoji
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(cancel))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))

        title = "Icon"

        previewView.roundCorners(radius: 10.0)
        previewLabel.text = "Preview Subscription"
        previewEmojiLabel.text = currentlySetEmoji ?? "❔"

        setColors()
    }

    // MARK: - Actions

    @objc private func cancel() {
        parent?.dismiss(animated: true, completion: nil)
    }

    // MARK: - Helpers

    private func setColors() {
        navigationController?.navigationBar.barTintColor = subColor.color
        navigationController?.navigationBar.tintColor = subColor.color.oppositeColorBasedOnBrightness()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: subColor.color.oppositeColorBasedOnBrightness()]
        view.backgroundColor = subColor == .black ? UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0) : subColor.color.darker(negative: 30)

        previewView.backgroundColor = subColor.color
        previewLabel.textColor = subColor.color.oppositeColorBasedOnBrightness()
    }

}

extension ColorAndIconShowViewController: ColorSelectorViewControllerDelegate {
    func didSelect(color: SubDefaultColors) {
        subColor = color
        UIView.animate(withDuration: 0.25) {
            self.setColors()
        }
    }

    func didSelect(emoji: String) {
        previewEmojiLabel.text = emoji
    }
}
