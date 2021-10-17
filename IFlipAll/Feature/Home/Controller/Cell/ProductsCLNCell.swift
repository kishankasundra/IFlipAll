//
//  ProductsCLNCell.swift
//  IFlipAll
//
//  Created by kishan on 24/11/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit

class ProductsCLNCell: UICollectionViewCell {
    
    @IBOutlet weak var imgProductList: UIImageView!
    
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var lblPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        DispatchQueue.main.async {
            self.priceView.layer.cornerRadius = 10.0
        }
    }
    
}
