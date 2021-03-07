//
//  ProductDetailVC.swift
//  IFlipAll
//
//  Created by kishan on 29/11/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit

class ProductDetailVC: UIViewController {

    @IBOutlet weak var clnViewProductDetailImg: UICollectionView!
    @IBOutlet weak var imgProductPic: UIImageView!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblAddedTime: UILabel!
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    var productDetail = ProductDetail()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.clnViewProductDetailImg.reloadData()
        
        if self.productDetail.Images[0] != ""
        {
            self.imgProductPic.sd_setImage(with: URL(string: self.productDetail.Images[0]), placeholderImage: UIImage(named: "ic_loginbg"))
        }
        
        let temp = self.productDetail
        
        self.lblProductPrice.text = "Rs." + temp.Price
        self.lblProductName.text = temp.Name
        self.lblAddedTime.text = ""
        self.imgUserProfile.sd_setImage(with: URL(string: temp.UserProfile), placeholderImage: UIImage(named: "ic_loginbg"))
        self.lblUserName.text = temp.UserName
        self.lblDescription.text = temp.Description
        
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSellerProfileAction(_ sender: UIButton) {
        
        let resultVC : ChatVC  = Utilities.viewController(name: "ChatVC", storyboard: "MyProfile") as! ChatVC
        resultVC.to_user_id = productDetail.UserId
        resultVC.to_user_name =  productDetail.UserName
        resultVC.to_user_image =  productDetail.UserProfile
        resultVC.isFromMemberList = true
        self.navigationController?.pushViewController(resultVC, animated: true)
        /*
        let resultVC : SellerProfileVC = Utilities.viewController(name: "SellerProfileVC", storyboard: "Home") as! SellerProfileVC
        self.navigationController?.pushViewController(resultVC, animated: true)*/
    }
    
    @IBAction func btnMakeOfferAction(_ sender: UIButton) {
        let resultVC : MakeOfferVC = Utilities.viewController(name: "MakeOfferVC", storyboard: "Home") as! MakeOfferVC
        self.navigationController?.pushViewController(resultVC, animated: true)
    }

}

extension ProductDetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.productDetail.Images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
         let cell: ProductDetailCLNCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductDetailCLNCell", for: indexPath) as! ProductDetailCLNCell
        
            cell.imgProductDetail.sd_setImage(with: URL(string: self.productDetail.Images[indexPath.row]), placeholderImage: UIImage(named: "ic_loginbg"))
        
  
        return cell
    }

    
}
