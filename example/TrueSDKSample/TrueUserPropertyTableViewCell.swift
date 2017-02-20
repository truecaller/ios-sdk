//
//  TrueUserPropertyTableViewCell.swift
//  SwiftTrueSDKHost
//
//  Created by Aleksandar Mihailovski on 22/12/16.
//  Copyright © 2016 True Software Scandinavia AB. All rights reserved.
//

import UIKit

class TrueUserPropertyTableViewCell: UITableViewCell {
    @IBOutlet weak var propertyNameLabel: UILabel!
    @IBOutlet weak var propertyValueLabel: UILabel!
    
    class func reuseIdentifier() -> String {
        return "TrueUserPropertyTableViewCellIdentifier"
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
