//
//  ProfileMenuTBLCell.swift
//  IFlipAll
//
//  Created by kishan on 27/11/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit

class ProfileMenuTBLCell: UITableViewCell {
    @IBOutlet weak var imgMenu: UIImageView!
    @IBOutlet weak var lblMenu: UILabel!
    @IBOutlet weak var viewBgMessges: UIView!
    @IBOutlet weak var lblMessagesCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
