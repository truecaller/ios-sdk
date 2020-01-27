//
//  LogViewController.swift
//  SwiftTrueSDKHost
//
//  Created by Aleksandar Mihailovski on 26/12/16.
//  Copyright © 2016 True Software Scandinavia AB. All rights reserved.
//

import UIKit

open class LogViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var logsTable: UITableView!

    override open func viewDidLoad() {
        super.viewDidLoad()

        logsTable.rowHeight = UITableView.automaticDimension
        logsTable.estimatedRowHeight = 60
    }

    //MARK: Button actions
    @IBAction func close(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clear(_ sender: UIBarButtonItem) {
        HostLogs.sharedInstance.clearLogs()
        logsTable.reloadData()
    }
    
    //MARK: UITableViewDataSource
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LogTableViewCell.reuseIdentifier()) as! LogTableViewCell
        let logModel: HostLog = HostLogs.sharedInstance.allLogs()[indexPath.row]
        cell.errorCodeLabel.text = (logModel.error as NSError).code.description
        cell.errorDateLabel.text = logModel.timestamp.description
        cell.errorDescriptionLabel.text = (logModel.error as NSError).localizedDescription
        return cell
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HostLogs.sharedInstance.allLogs().count
    }
}
