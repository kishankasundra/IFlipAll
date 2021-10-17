//
//  SellProductTableViewCell.swift
//  IFlipAll
//
//  Created by devangs.bhatt on 12/06/21.
//  Copyright © 2021 StarkTechnolabs. All rights reserved.
//

import UIKit

class SellProductTableViewCell: UITableViewCell {

    @IBOutlet weak var imgProcuct: UIImageView!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var availabilityView: UIView!
    @IBOutlet weak var priceView: UIView!
    
    @IBOutlet weak var lblAvailability: UILabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnSold: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        DispatchQueue.main.async {
            self.btnEdit.layer.cornerRadius = self.btnEdit.bounds.height / 2.0
            self.availabilityView.layer.cornerRadius = 14.0
            self.priceView.layer.cornerRadius = 14.0
            self.roundCorners(with: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: 20)
        }
    }

    private func roundCorners(with CACornerMask: CACornerMask, radius: CGFloat) {
        mainView.layer.borderColor = appColors.gray.cgColor
        mainView.layer.borderWidth = 0.5
        mainView.layer.cornerRadius = radius
        mainView.layer.maskedCorners = [CACornerMask]
    }
    
    @IBAction func btnDeleteAction(_ sender: UIButton) {

    }
    
    @IBAction func btnSoldAction(_ sender: UIButton) {
        
    }

    @IBAction func btnEditAction(_ sender: UIButton) {
        
    }

}
