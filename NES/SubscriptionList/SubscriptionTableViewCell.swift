//
//  SubscriptionTableViewCell.swift
//  NES
//
//  Created by Andrew Robinson on 9/18/18.
//  Copyright © 2018 XYello, Inc. All rights reserved.
//

import UIKit

class SubscriptionTableViewCell: UITableViewCell {

    @IBOutlet weak var detailView: UIView!

    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var occurenceLabel: UILabel!

    struct ViewModel {
        let title: String
        let description: String?
        let cost: Double
        let backgroundColor: UIColor
        let emoji: String?
        let occurenceCycle: OccurenceCycle
        let occurencePeriod: Int
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none

        detailView.roundCorners(radius: 10.0)
        detailView.backgroundColor = .black

        titleLabel.textColor = .white
    }

    func configure(with viewModel: ViewModel) {
        detailView.backgroundColor = viewModel.backgroundColor

        titleLabel.text = viewModel.title
        titleLabel.textColor = viewModel.backgroundColor.oppositeColorBasedOnBrightness()

        if let description = viewModel.description {
            descriptionLabel.text = description
            descriptionLabel.textColor = viewModel.backgroundColor.oppositeColorBasedOnBrightness()
            descriptionLabel.isHidden = false
        } else {
            descriptionLabel.isHidden = true
        }

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        let costFormatted = formatter.string(from: viewModel.cost as NSNumber)
        costLabel.text = costFormatted
        costLabel.textColor = viewModel.backgroundColor.oppositeColorBasedOnBrightness()

        switch viewModel.occurenceCycle {
        case .month:
            if viewModel.occurencePeriod == 1 {
                occurenceLabel.text = "/ month"
            } else {
                occurenceLabel.text = "Every \(viewModel.occurencePeriod) months"
            }
        case .year:
            if viewModel.occurencePeriod == 1 {
                occurenceLabel.text = "/ year"
            } else {
                occurenceLabel.text = "Every \(viewModel.occurencePeriod) years"
            }
        case .day:
            if viewModel.occurencePeriod == 1 {
                occurenceLabel.text = "/ day"
            } else {
                occurenceLabel.text = "Every \(viewModel.occurencePeriod) days"
            }
        }
        occurenceLabel.textColor = viewModel.backgroundColor.oppositeColorBasedOnBrightness()

        if let emoji = viewModel.emoji {
            emojiLabel.text = emoji
        }
    }

}
