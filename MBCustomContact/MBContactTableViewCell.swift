//
//  MBContactTableViewCell.swift
//  MBCustomContact
//
//  Created by Mac on 9/29/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class MBContactTableViewCell: UITableViewCell {
    @IBOutlet weak var selectCountryButton: UIButton!
    @IBOutlet weak var emailDField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var mobileNoField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
