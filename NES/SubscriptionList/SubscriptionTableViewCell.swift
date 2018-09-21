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

    @IBOutlet weak var titleLabel: UILabel!

    struct ViewModel {
        let title: String
        let backgroundColor: UIColor
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none

        detailView.roundCorners(radius: 10.0)
        detailView.backgroundColor = .black

        titleLabel.textColor = .white
    }

    func configure(with viewModel: ViewModel) {
        titleLabel.text = viewModel.title
        detailView.backgroundColor = viewModel.backgroundColor
    }

}
