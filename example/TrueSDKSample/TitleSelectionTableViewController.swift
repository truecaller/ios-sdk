//
//  TitleSelectionTableViewController.swift
//  TrueSDKSample
//
//  Created by Sreedeepkesav M S on 02/01/20.
//  Copyright © 2020 Aleksandar Mihailovski. All rights reserved.
//

import UIKit
import TrueSDK

protocol TitleSelectionTableViewControllerDelegate: class {
    func didSet(title: TitleType)
}

class TitleSelectionTableViewController: UITableViewController {
    private let titles = ["Default",
                          "Login to",
                          "Sign up with",
                          "Sign in to",
                          "Verify with",
                          "Get started with",
                          "Register with"]
    
    weak var delegate: TitleSelectionTableViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
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
        presentAlertForTitleChange(with: title, titleName: titles[indexPath.row])
    }
    
    private func presentAlertForTitleChange(with title: TitleType, titleName: String) {
        let alert = UIAlertController(title: "",
                                      message: "Title set to: \(titleName)",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: { [weak self] action in
                                        self?.delegate?.didSet(title: title)
                                        self?.dismiss(animated: true, completion: nil)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func titleType(for index: Int) -> TitleType {
        return TitleType(rawValue: index) ?? .default
    }
}
