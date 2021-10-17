//
//  SearchVC.swift
//  IFlipAll
//
//  Created by devangs.bhatt on 10/06/21.
//  Copyright © 2021 StarkTechnolabs. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {
    
    @IBOutlet weak var productCLNView: UICollectionView!
    @IBOutlet weak var txtSearch: UITextField!
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var clearSearchView: UIView!
    
    @IBOutlet weak var lblclearSearch: UILabel!
    @IBOutlet weak var lblDataNotFound: UILabel!
    @IBOutlet weak var btnClearSearch: UIButton!
    
    @IBOutlet weak var productCLNViewHeightConstaint: NSLayoutConstraint!
    @IBOutlet weak var clearSearchViewHeightConstraint: NSLayoutConstraint!
    
    var arrProductDetails: [ProductDetail] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        productsAPICall()        
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSearchAction(_ sender: UIButton) {
        guard txtSearch.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 > 0 else { return }
        productsAPICall(searchText: txtSearch.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
        txtSearch.resignFirstResponder()
    }
    
    @IBAction func btnFilterAction(_ sender: UIButton) {
    }
    
    @IBAction func btnClearSearchAction(_ sender: UIButton) {
        txtSearch.text = ""
        productsAPICall()
    }
}

// MARK: - Custom Methods
extension SearchVC {
    // API Calling
    // Search Products
    
    func productsAPICall(searchText: String = "") {
     
        var param : [String:Any] = ["UserId":kCurrentUser.UserId,
                                    "Category": "",
                                    "Subcategory": "",
                                    "MinPrice": "",
                                    "MaxPrice": "",
                                    "PageId": 0,
                                    "PerPage": 300,
                                    "Sort":1,
                                    "Distance": 10000]
        
        if searchText.count > 0 {
            param = param.merging(["SearchKeyWord" : searchText]) { $1 }
        }

        AlamofireModel.alamofireMethod(.post, apiAction: .AllProdcutList, parameters: param, Header: [:], handler:{res in

            if res.success == 1
            {
                
                guard let productJSONData = JSON(res.json).array?.first?.dictionaryValue["ProductData"] else {
                    return
                }
                
                productlist = ProductList()
                productlist.update(productJSONData)
                
                if searchText.count == 0 {
                    self.arrProductDetails = productlist.productdetail.filter({ $0.ProductType == "1" })
                    productlist.productdetail = productlist.productdetail.filter({ $0.ProductType == "1" })
                } else {
                    self.arrProductDetails = productlist.productdetail
                }
                
                self.lblDataNotFound.isHidden = self.arrProductDetails.count != 0

                if searchText.count > 0 { // Searching product
                    self.clearSearchViewHeightConstraint.constant = 40
                    self.lblclearSearch.text = "Search result for \(searchText)"
                    self.clearSearchView.isHidden = false
                    self.lblclearSearch.isHidden = false
                    self.btnClearSearch.isHidden = false
                } else {
                    self.clearSearchViewHeightConstraint.constant = 0
                    self.clearSearchView.isHidden = true
                    self.lblclearSearch.isHidden = true
                    self.btnClearSearch.isHidden = true
                }
                self.productCLNView.reloadData()
                DispatchQueue.main.async {
                    self.view.layoutIfNeeded()
                    self.productCLNViewHeightConstaint.constant = self.productCLNView.contentSize.height
                    self.productCLNView.reloadData()
                }
            }
            else if JSON(res.json).array?.count == 0, res.success == 2 {
                self.arrProductDetails.removeAll()
                self.lblDataNotFound.isHidden = false
                if searchText.count > 0 { // Searching product
                    self.clearSearchViewHeightConstraint.constant = 40
                    self.lblclearSearch.text = "Search result for \"\(searchText)\""
                    self.clearSearchView.isHidden = false
                    self.lblclearSearch.isHidden = false
                    self.btnClearSearch.isHidden = false
                } else {
                    self.clearSearchViewHeightConstraint.constant = 0
                    self.clearSearchView.isHidden = true
                    self.lblclearSearch.isHidden = true
                    self.btnClearSearch.isHidden = true
                }
                self.productCLNView.reloadData()
                DispatchQueue.main.async {
                    self.view.layoutIfNeeded()
                    self.productCLNViewHeightConstaint.constant = ScreenHeight
                    self.productCLNView.reloadData()
                }
            } else {
                AppInstance.showMessages(message: res.message)
            }
        }, errorhandler: {error in
            AppInstance.showMessages(message: error.localizedDescription)
        })
    }
}


// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout Methods
extension SearchVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrProductDetails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: ProductsCLNCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductsCLNCell", for: indexPath) as! ProductsCLNCell
        
        let temp = arrProductDetails[indexPath.row]
        cell.lblPrice.text = "$\(temp.Price)"
        if temp.Images.count > 0 && temp.Images[0] != ""
        {
            let temp = productlist.productdetail[indexPath.row].Images[0]
            cell.imgProductList.sd_setImage(with: URL(string: temp), placeholderImage:UIImage(named: "ic_home_top_bg_new"))
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (ScreenWidth-4)/3
        //return CGSize(width: width, height: (width * CGFloat(productlist.productdetail.count)))
        return CGSize(width: width, height: 100)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let resultVC : ProductDetailVC = Utilities.viewController(name: "ProductDetailVC", storyboard: "Home") as! ProductDetailVC
        resultVC.productDetail = arrProductDetails[indexPath.row]
            //productlist.productdetail[indexPath.row]
        self.navigationController?.pushViewController(resultVC, animated: true)
    }
    
}

// MARK: -  UITextFieldDelegate Methods
extension SearchVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard txtSearch.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 > 0 else { return false }
        productsAPICall(searchText: txtSearch.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
        return true
    }
    
}
