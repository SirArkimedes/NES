//
//  SubscriptionListViewController.swift
//  NES
//
//  Created by Andrew Robinson on 9/18/18.
//  Copyright © 2018 XYello, Inc. All rights reserved.
//

import UIKit

class SubscriptionListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed)), animated: false)

        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: String(describing: SubscriptionTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: SubscriptionTableViewCell.self))

        SubscriptionManager.instance.bind { (subscriptions) in
            self.tableView.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Actions

    @objc private func addButtonPressed() {
        present(AddSubListViewController(), animated: true, completion: nil)
    }

}

extension SubscriptionListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SubscriptionManager.instance.getSubscriptionCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SubscriptionTableViewCell.self), for: indexPath) as! SubscriptionTableViewCell

        let sub = SubscriptionManager.instance.getSubscriptionAt(index: indexPath.row)
        cell.configure(with: SubscriptionTableViewCell.ViewModel(title: sub.name))

        return cell
    }
}
