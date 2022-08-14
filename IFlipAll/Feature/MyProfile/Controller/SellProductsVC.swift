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
        resultVC.isForEdit = true
//        resultVC.myProductDetail = productlist.productdetail[sender.tag]
        self.navigationController?.pushViewController(resultVC, animated: true)
    }
    
    @objc func btnDeleteAction(_ sender : UIButton) {
        
        guard let productId = Int(productlist.productdetail[sender.tag].Id) else { return }
        
        let alert = UIAlertController(title: "", message: "Are you sure you want to delete this product?".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes".localized, style: .default) { action in
            self.APIDeleteProduct(productId: productId, index: sender.tag)
        })
        
        alert.addAction(UIAlertAction(title: "No".localized, style: .default) { action in
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func btnSoldAction(_ sender : UIButton) {
        let alert = UIAlertController(title: "", message: "Are you sure you want to mark this item as sold?".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes".localized, style: .default) { action in
            self.APISoldProduct(productDetail: productlist.productdetail[sender.tag], index: sender.tag)
        })
        
        alert.addAction(UIAlertAction(title: "No".localized, style: .default) { action in
        })
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension SellProductsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productlist.productdetail.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: SellProductsCLNCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SellProductsCLNCell", for: indexPath) as! SellProductsCLNCell
        
        cell.btnEdit.tag = indexPath.row
        cell.btnDelete.tag = indexPath.row
        cell.btnSold.tag = indexPath.row

        cell.btnEdit.addTarget(self, action: #selector(btnEditAction), for: .touchUpInside)
        cell.btnDelete.addTarget(self, action: #selector(btnDeleteAction(_:)), for: .touchUpInside)
        cell.btnSold.addTarget(self, action: #selector(btnSoldAction(_:)), for: .touchUpInside)

        
        let temp = productlist.productdetail[indexPath.row]
        
        if temp.Images.count > 0 && temp.Images[0] != ""
        {
            cell.imgMyProduct.sd_setImage(with: URL(string: temp.Images[0]), placeholderImage:UIImage(named: "ic_loginbg"))
        }
        
        cell.btnSold.isHidden = temp.isButtonHide ?? false
        cell.btnDelete.isHidden = temp.isButtonHide ?? false
        cell.btnEdit.isHidden = temp.isButtonHide ?? false
        cell.priceView.isHidden = (temp.isButtonHide ?? false || temp.ProductType == "2")
        cell.statusView.backgroundColor = (temp.SoldStatus == "sold" ) ? UIColor.red : appColors.purpleColor
        
        cell.lblStatus.text = temp.manageSoldStatus
        cell.lblPrice.text = (temp.SoldStatus == "sold" || temp.ProductType == "2") ? "" : "$" + temp.Price
        cell.lblName.text = temp.Name

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         return CGSize(width: (ScreenWidth-32), height: 185)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let resultVC : ProductDetailVC = Utilities.viewController(name: "ProductDetailVC", storyboard: "Home") as! ProductDetailVC
        resultVC.productDetail = productlist.productdetail[indexPath.row]
        self.navigationController?.pushViewController(resultVC, animated: true)
    }
    
}

extension SellProductsVC {
    func APIMyProductList() {
        let param : [String:Any] = ["UserId":kCurrentUser.UserId]

        AlamofireModel.alamofireMethod(.post, apiAction: .MyProductList, parameters: param, Header: [:], handler:{res in

            if res.success == 1 {
                productlist = ProductList()
                productlist.update(res.json)
                
                DispatchQueue.main.async {
                    self.clnViewSellProduct.dataSource = self
                    self.clnViewSellProduct.delegate = self
                    self.clnViewSellProduct.reloadData()
                }
                                 
            }
            else {
                AppInstance.showMessages(message: res.message)
            }
        }, errorhandler: {error in
            AppInstance.showMessages(message: error.localizedDescription)
        })
    }
    
    func APIDeleteProduct(productId: Int, index: Int) {
        let param : [String:Any] = ["ProductId":productId]

        AlamofireModel.alamofireMethod(.post, apiAction: .DeleteProduct, parameters: param, Header: [:], handler:{res in

            if res.success == 1 {
                productlist.productdetail.remove(at: index)
                self.clnViewSellProduct.deleteItems(at: [IndexPath(item: index, section: 0)])
            }
            else {
                AppInstance.showMessages(message: res.message)
            }
        }, errorhandler: {error in
            AppInstance.showMessages(message: error.localizedDescription)
        })
    }
    
    func APISoldProduct(productDetail: ProductDetail, index: Int) {
        var categoryId: Int?
        var subCategoryId: Int?
        
        if let result = UserDefaults.standard.string(forKey: "categorylist"),  let jsonData = result.data(using: .utf8), let storedJson = try? JSON(data: jsonData) {
            
            categorylist = CategoryList()
            
            if let categoryJson = storedJson.array?.first?.dictionaryValue["Category"] {
                categorylist.update(categoryJson)
            }
            
            categoryId = Int(categorylist.detail.filter({ $0.CategoryName == productDetail.CategoryName }).first?.CatId ?? "0") ?? 0
            
            if let subCategoryJson = storedJson.array?.first?.dictionaryValue["SubCategory"] {
                categorylist.updateSubCategory(subCategoryJson)
            }
            
            subCategoryId = Int(categorylist.subCategorydetail.filter({ $0.SubCategoryName == productDetail.SubCategoryName }).first?.SubCategoryId ?? "0") ?? 0
        }
        
        
        let param: [String: Any] = ["ProductId": Int(productDetail.Id) ?? 0,
                                    "CategoryId": categoryId ?? 0,
                                    "SubCategoryId": subCategoryId ?? 0,
                                    "UserId": Int(kCurrentUser.UserId) ?? 0,
                                    "Name": productDetail.Name,
                                    "Price": Int(productDetail.Price) ?? 0,
                                    "Description": productDetail.Description,
                                    "Condition": productDetail.Condition,
                                    "Images": productDetail.Images,
                                    "Longitude": productDetail.Longitude,
                                    "Langitude": productDetail.Langitude,
                                    "Address": productDetail.Address,
                                    "Negotiation": productDetail.Negotiation,
                                    "SoldStatus": "2"]
        
        AlamofireModel.alamofireMethod(.post, apiAction: .EditProduct, parameters: param, Header: [:], handler:{res in

            if res.success == 1 {
                productDetail.SoldStatus = "sold"
                self.clnViewSellProduct.reloadItems(at: [IndexPath(item: index, section: 0)])
            }
            else {
                AppInstance.showMessages(message: res.message)
            }
        }, errorhandler: {error in
            AppInstance.showMessages(message: error.localizedDescription)
        })
    }
}
