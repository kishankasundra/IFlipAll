//
//  ProductListingVC.swift
//  IFlipAll
//
//  Created by kishan on 29/11/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit

class ProductListingVC: UIViewController {
    
    @IBOutlet weak var lblCategoryName: UILabel!
    
    var categoryName = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.lblCategoryName.text = self.categoryName
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnFilterAction(_ sender: UIButton) {
        let resultVC : FilterVC = Utilities.viewController(name: "FilterVC", storyboard: "Home") as! FilterVC
        self.navigationController?.pushViewController(resultVC, animated: true)
    }
}

extension ProductListingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: ProductListingCLNCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductListingCLNCell", for: indexPath) as! ProductListingCLNCell
        
        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (ScreenWidth-49)/2, height: 235)

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let resultVC : ProductDetailVC = Utilities.viewController(name: "ProductDetailVC", storyboard: "Home") as! ProductDetailVC
//        self.navigationController?.pushViewController(resultVC, animated: true)
    }
    
    
}
