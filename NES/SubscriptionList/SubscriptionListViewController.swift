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
        title = "Subscriptions"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed)), animated: false)
        navigationItem.setLeftBarButton(UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(settingsButtonPressed)), animated: false)

        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: String(describing: SubscriptionTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: SubscriptionTableViewCell.self))

        tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: view.safeAreaInsets.bottom, right: 0.0)

        SubscriptionManager.instance.bind {
            self.tableView.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Actions

    @objc private func settingsButtonPressed() {
        //
    }

    @objc private func addButtonPressed() {
        let vc = NewSubscriptionViewController()
        let nvc = UINavigationController(rootViewController: vc)
        present(nvc, animated: true, completion: nil)
    }

}

extension SubscriptionListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SubscriptionManager.instance.getSubscriptionCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SubscriptionTableViewCell.self), for: indexPath) as! SubscriptionTableViewCell

        let sub = SubscriptionManager.instance.getSubscriptionAt(index: indexPath.row)
        let color = UIColor.color(red: sub.colorRed, green: sub.colorGreen, blue: sub.colorBlue)
        cell.configure(with: SubscriptionTableViewCell.ViewModel(title: sub.name, description: sub.descriptionText, cost: sub.cost, backgroundColor: color, emoji: sub.emojiIcon, occurenceCycle: sub.occurenceCycle, occurencePeriod: sub.occurencePeriod))

        return cell
    }
}

extension SubscriptionListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = SubscriptionDetailViewController(subscription: SubscriptionManager.instance.getSubscriptionAt(index: indexPath.row))
        navigationController?.pushViewController(vc, animated: true)
    }
}
