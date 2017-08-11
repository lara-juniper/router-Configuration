//
//  ConfigCell.swift
//  Router Configuration
//
//  Created by Lara Orlandic on 8/11/17.
//  Copyright © 2017 Lara Orlandic. All rights reserved.
//

import UIKit

class ConfigCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var routerNumber: UILabel!
    
    @IBOutlet weak var junosVersion: UILabel!

}
