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
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var occurrenceLabel: UILabel!

    struct ViewModel {
        let title: String
        let cost: Double
        let backgroundColor: UIColor
        let emoji: String?
        let occurrenceCycle: OccurrenceCycle
        let occurrencePeriod: Int
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

        costLabel.text = viewModel.cost.displayedAsCurrency()
        costLabel.textColor = viewModel.backgroundColor.oppositeColorBasedOnBrightness()

        switch viewModel.occurrenceCycle {
        case .month:
            if viewModel.occurrencePeriod == 1 {
                occurrenceLabel.text = "/ month"
            } else {
                occurrenceLabel.text = "Every \(viewModel.occurrencePeriod) months"
            }
        case .year:
            if viewModel.occurrencePeriod == 1 {
                occurrenceLabel.text = "/ year"
            } else {
                occurrenceLabel.text = "Every \(viewModel.occurrencePeriod) years"
            }
        case .day:
            if viewModel.occurrencePeriod == 1 {
                occurrenceLabel.text = "/ day"
            } else {
                occurrenceLabel.text = "Every \(viewModel.occurrencePeriod) days"
            }
        }
        occurrenceLabel.textColor = viewModel.backgroundColor.oppositeColorBasedOnBrightness()

        if let emoji = viewModel.emoji {
            emojiLabel.text = emoji
        }
    }

}
