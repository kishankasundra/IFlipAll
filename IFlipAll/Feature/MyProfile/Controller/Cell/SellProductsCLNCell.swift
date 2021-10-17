//
//  SellProductsCLNCell.swift
//  IFlipAll
//
//  Created by kishan on 28/11/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit

class SellProductsCLNCell: UICollectionViewCell {
    
    @IBOutlet weak var imgMyProduct: UIImageView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnSold: UIButton!
    
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var statusView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        DispatchQueue.main.async {
            self.btnEdit.layer.cornerRadius = self.btnEdit.bounds.height / 2.0
        }
    }
}
