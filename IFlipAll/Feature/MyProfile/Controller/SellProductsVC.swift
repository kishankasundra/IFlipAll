//
//  SellProductsVC.swift
//  IFlipAll
//
//  Created by kishan on 28/11/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit

class SellProductsVC: UIViewController {

    @IBOutlet weak var clnViewSellProduct: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.APIMyProductList()
        
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
           self.navigationController?.popViewController(animated: true)
       }
    
    @objc func btnEditAction(_ sender : UIButton)
    {
        let resultVC : PostAnItemTabVC = Utilities.viewController(name: "PostAnItemTabVC", storyboard: "Home") as! PostAnItemTabVC
        resultVC.isEdit = "Edit"
        resultVC.myProductDetail = myProductList.myProductDetail[sender.tag]
        self.navigationController?.pushViewController(resultVC, animated: true)
    }

}

extension SellProductsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return myProductList.myProductDetail.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: SellProductsCLNCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SellProductsCLNCell", for: indexPath) as! SellProductsCLNCell
        
        cell.btnEdit.tag = indexPath.row
        cell.btnEdit.addTarget(self, action: #selector(btnEditAction), for: .touchUpInside)
        
        let temp = myProductList.myProductDetail[indexPath.row]
        
        if temp.Images.count > 0 && temp.Images[0] != ""
        {
            cell.imgMyProduct.sd_setImage(with: URL(string: temp.Images[0]), placeholderImage:UIImage(named: "ic_loginbg"))
        }
        
        cell.lblPrice.text = "Rs. " + temp.Price
        cell.lblName.text = temp.Name

        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
         return CGSize(width: (ScreenWidth-32), height: 185)

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let resultVC : ProductDetailVC = Utilities.viewController(name: "ProductDetailVC", storyboard: "Home") as! ProductDetailVC
//        self.navigationController?.pushViewController(resultVC, animated: true)
    }
    
}

extension SellProductsVC
{
    func APIMyProductList()
    {
     
        let param : [String:Any] = ["UserId":"1"]

        AlamofireModel.alamofireMethod(.post, apiAction: .MyProductList, parameters: param, Header: [:], handler:{res in

            if res.success == 1
            {
                myProductList = MyProductList()
                myProductList.update(res.json)
                self.clnViewSellProduct.reloadData()
                                 
            }
            else
            {
                AppInstance.showMessages(message: res.message)
            }
           

        }, errorhandler: {error in

            AppInstance.showMessages(message: error.localizedDescription)

        })
    }
}
