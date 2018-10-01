//
//  MBConatctDisplayTableViewCell.swift
//  MBCustomContact
//
//  Created by Mac on 9/30/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class MBConatctDisplayTableViewCell: UITableViewCell {
    @IBOutlet weak var subtitleContact: UILabel!
    @IBOutlet weak var displayImage: UIImageView!
    @IBOutlet weak var titleContact: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
