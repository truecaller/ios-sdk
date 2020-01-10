//
//  QATitleSelectionTableViewController.swift
//  TrueSDKSample
//
//  Created by Sreedeepkesav M S on 02/01/20.
//  Copyright © 2020 Aleksandar Mihailovski. All rights reserved.
//

import UIKit
import TrueSDK

extension Notification.Name {
    static let titleChanged = Notification.Name("loginTitleChanged")
}

private var titles : [String] {
    return ["Default",
            "Login to",
            "Sign up with",
            "Sign in to",
            "Verify with",
            "Get started with",
            "Register with"]
}

class QATitleSelectionTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = titles[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = titleType(for: indexPath.row)
        postNotificationForTitleChange(with: title, titleName: titles[indexPath.row])
    }
}

extension QATitleSelectionTableViewController {
    private func postNotificationForTitleChange(with title: TitleType, titleName: String) {
        NotificationCenter.default.post(name: .titleChanged,
                                        object: nil,
                                        userInfo: ["titleType": title])
        
        let alert = UIAlertController(title: "",
                                      message: "Title set to: \(titleName)",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func titleType(for index: Int) -> TitleType {
        return TitleType(rawValue: index) ?? .default
    }
}
