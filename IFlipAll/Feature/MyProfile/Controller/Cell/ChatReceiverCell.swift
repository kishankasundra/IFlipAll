//
//  MessageChetCell.swift
//  Fighter Connect
//
//  Created by kishan on 01/06/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit

class ChatReceiverCell: UITableViewCell {

    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var viewMain: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewMain.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
