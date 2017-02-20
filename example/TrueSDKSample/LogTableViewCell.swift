//
//  LogTableViewCell.swift
//  SwiftTrueSDKHost
//
//  Created by Aleksandar Mihailovski on 27/12/16.
//  Copyright © 2016 True Software Scandinavia AB. All rights reserved.
//

import UIKit

class LogTableViewCell: UITableViewCell {
    @IBOutlet weak var errorCodeLabel: UILabel!
    @IBOutlet weak var errorDescriptionLabel: UILabel!
    @IBOutlet weak var errorDateLabel: UILabel!
    
    class func reuseIdentifier() -> String {
        return "LogTableViewCellIdentifier"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
