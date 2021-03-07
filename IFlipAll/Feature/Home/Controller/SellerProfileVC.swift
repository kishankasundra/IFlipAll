//
//  SellerProfileVC.swift
//  IFlipAll
//
//  Created by kishan on 29/11/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit

class SellerProfileVC: UIViewController {

    @IBOutlet weak var clnViewSellerProduct: UICollectionView!
    @IBOutlet weak var clnViewSellerProductHights: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.layoutIfNeeded()
        self.clnViewSellerProductHights.constant = 3000
        self.clnViewSellerProductHights.constant = self.clnViewSellerProduct.contentSize.height
        self.clnViewSellerProduct.reloadData()
        
    }
    
    @IBAction func btnCoomentListAction(_ sender: UIButton) {
        let resultVC : CommentVC = Utilities.viewController(name: "CommentVC", storyboard: "Home") as! CommentVC
        self.navigationController?.pushViewController(resultVC, animated: true)
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


extension SellerProfileVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 5
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: SellerProfileCLNCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SellerProfileCLNCell", for: indexPath) as! SellerProfileCLNCell
        
        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (ScreenWidth-49)/2, height: 235)

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let resultVC : ProductDetailVC = Utilities.viewController(name: "ProductDetailVC", storyboard: "Home") as! ProductDetailVC
        self.navigationController?.pushViewController(resultVC, animated: true)
    }
    
    
}
