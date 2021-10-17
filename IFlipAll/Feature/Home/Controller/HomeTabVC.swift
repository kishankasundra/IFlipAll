//
//  HomeTabVC.swift
//  IFlipAll
//
//  Created by kishan on 24/11/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit
import SDWebImage

class HomeTabVC: UIViewController {
    
    @IBOutlet weak var categoryCLNView: UICollectionView!
    @IBOutlet weak var productsCLNView: UICollectionView!
    @IBOutlet weak var productCLNViewHeights: NSLayoutConstraint!
    var ratio: [CGFloat] = [1.3,1.2,0.9,0.6,0.7,2.7,1.2,0.8,1.0,1.3,1.2,0.7,0.6,2.4,0.7,1.2,0.8,1.0]
    
    @IBOutlet weak var lblSellCounts: UILabel!
    @IBOutlet weak var lblFreeCount: UILabel!
    @IBOutlet weak var lblRequestCount: UILabel!
    
    @IBOutlet weak var btnSell: UIButton!
    @IBOutlet weak var btnFree: UIButton!
    @IBOutlet weak var btnRequest: UIButton!
    @IBOutlet weak var btnAddItem: UIButton!
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var btnSearch: UIButton!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var sellSeparatorView: UIView!
    @IBOutlet weak var freeSeparatorView: UIView!
    @IBOutlet weak var requestSeparatorView: UIView!
    @IBOutlet weak var searchView: UIView!
    
    var filterProductByProductType: [ProductDetail] = []
    
    let fetcher = ImageSizeFetcher()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = productsCLNView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        self.APICategoryList()
        self.APIAllProdcutList()
        profileImageView.contentMode = profileImageView.image == UIImage(named: "ic_user_new") ? .center : .scaleAspectFill
        profileImageView.sd_setImage(with: URL(string: kCurrentUser.ProfileImage), placeholderImage: UIImage(named: "ic_default_profile"))

    }
    
    @IBAction func btnAddItemAction(_ sender: UIButton) {
    }
    
    @IBAction func btnSearchAction(_ sender: UIButton) {
        let searchVC: SearchVC = Utilities.viewController(name: "SearchVC", storyboard: "Home") as! SearchVC
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @IBAction func btnFilterAction(_ sender: UIButton) {
    }
    
    @IBAction func btnSortingtAction(_ sender: UIButton) {
        [sellSeparatorView, freeSeparatorView, requestSeparatorView].forEach({ $0.backgroundColor = appColors.separatorColor })
        switch sender.tag {
        case 11: // Sell Button
            sellSeparatorView.backgroundColor = appColors.purpleColor
            filterProductByProductType = productlist.productdetail.filter({ $0.ProductType == "1" })
            btnAddItem.setTitle("Add Sell Item", for: .normal)
        case 22: // Free Button
            freeSeparatorView.backgroundColor = appColors.purpleColor
            filterProductByProductType = productlist.productdetail.filter({ $0.ProductType == "2" })
            btnAddItem.setTitle("Add Free Item", for: .normal)
        case 33: // Request Button
            requestSeparatorView.backgroundColor = appColors.green
            filterProductByProductType = productlist.productdetail.filter({ $0.ProductType == "3" })
            btnAddItem.setTitle("Add Need Item", for: .normal)
        default: return
        }
        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
            //            self.productCLNViewHeights.constant = 3000
            self.productCLNViewHeights.constant = self.productsCLNView.contentSize.height
            //self.productsCLNView.contentSize.height
            self.productsCLNView.reloadData()
        }
    }
    
    @IBAction func btnViewAllCategoryAction(_ sender: UIButton) {
        
        let resultVC: ProductListingVC = Utilities.viewController(name: "ProductListingVC", storyboard: "Home") as! ProductListingVC
        resultVC.categoryName = "Search result for “Mobile”"
        self.navigationController?.pushViewController(resultVC, animated: true)
        
    }
    
    
}

extension HomeTabVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == categoryCLNView
        {
            return categorylist.detail.count
        }
        else
        {
            return filterProductByProductType.count//productlist.productdetail.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == categoryCLNView
        {
            let cell: CategoryCLNCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCLNCell", for: indexPath) as! CategoryCLNCell
            
            let temp = categorylist.detail[indexPath.row]
            cell.imgCategory.sd_setImage(with: URL(string: temp.Icon), placeholderImage:UIImage(named: "ic_mobile_category"))
            cell.lblCategory.text = temp.CategoryName
            
            return cell
        }
        else
        {
            let cell: ProductsCLNCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductsCLNCell", for: indexPath) as! ProductsCLNCell
            
            let temp = filterProductByProductType[indexPath.row]
            cell.lblPrice.text = temp.ProductType == "2" ? "Free" : "$\(temp.Price)"
            if temp.Images.count > 0 && temp.Images[0] != ""
            {
                let temp = filterProductByProductType[indexPath.row].Images[0]
                cell.imgProductList.sd_setImage(with: URL(string: temp), placeholderImage:UIImage(named: "ic_home_top_bg_new"))
//                
//                DispatchQueue.global(qos: .userInitiated).async {
//                    
//                   let imageData:NSData = NSData(contentsOf: URL(string: temp)!)!
//
//                    
//                }
                
//                fetcher.sizeFor(atURL: URL(string: temp)!) { err, imageSize in
//                    print("Image Size:-->", NSCoder.string(for: imageSize?.size ?? CGSize()))
//                }
            }
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == categoryCLNView
        {
            return CGSize(width: 108, height: 108)
        }
        else
        {
            let width = (ScreenWidth-4)/3
            //return CGSize(width: width, height: (width * CGFloat(productlist.productdetail.count)))
            return CGSize(width: width, height: (width * self.ratio[indexPath.row]))
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == categoryCLNView
        {
            let resultVC: ProductListingVC = Utilities.viewController(name: "ProductListingVC", storyboard: "Home") as! ProductListingVC
            resultVC.categoryName = "Search result for “Mobile”"
            self.navigationController?.pushViewController(resultVC, animated: true)
        }
        else
        {
            let resultVC : ProductDetailVC = Utilities.viewController(name: "ProductDetailVC", storyboard: "Home") as! ProductDetailVC
            resultVC.productDetail = filterProductByProductType[indexPath.row]//productlist.productdetail[indexPath.row]
            self.navigationController?.pushViewController(resultVC, animated: true)
        }
        
    }
    
}

extension HomeTabVC: PinterestLayoutDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        let width = (ScreenWidth-4)/3
        return (width)//* self.ratio[indexPath.row])
    }
}

extension HomeTabVC
{
    func clnViewHeight()
    {
        //        var items:Int = 3
        //        var clnViewHeights:Int = 0
        //
        //        if items%2 == 0
        //        {
        //            clnViewHeights = 235*((items/2)-1)
        //        }
        //        else
        //        {
        //            items -= 1
        //            if items > 2
        //            {
        //                clnViewHeights = 235*((items/2)-1)
        //            }
        //            else
        //            {
        //                clnViewHeights = 235*((items/2))
        //            }
        //
        //        }
        //        self.productCLNViewHeights.constant = ScreenHeight-380//CGFloat(clnViewHeights)
        
        
    }
}

extension HomeTabVC
{
    func APICategoryList()
    {
        
        let param : [String:Any] = [:]
        
        AlamofireModel.alamofireMethod(.post, apiAction: .CategoryList, parameters: param, Header: [:], handler:{res in
            
            if res.success == 1
            {
                //                    categorylist = CategoryList()
                //                    categorylist.update(res.json)
                //                    self.categoryCLNView.reloadData()
                
                if let jsonString = res.json.rawString() {
                    UserDefaults.standard.setValue(jsonString, forKey: "categorylist")
                }
                
                if let result = UserDefaults.standard.string(forKey: "categorylist"),  let jsonData = result.data(using: .utf8), let storedJson = try? JSON(data: jsonData) {
                    
                    categorylist = CategoryList()
                    
                    if let categoryJson = storedJson.array?.first?.dictionaryValue["Category"] {
                        categorylist.update(categoryJson)
                    }
                    if let subCategoryJson = storedJson.array?.first?.dictionaryValue["SubCategory"] {
                        categorylist.updateSubCategory(subCategoryJson)
                    }
                    print("Category count: ->>", categorylist.detail.count)
                    print("Sub Category count: ->>", categorylist.subCategorydetail.count)
                }
                
            }
            else
            {
                AppInstance.showMessages(message: res.message)
            }
            
            
        }, errorhandler: {error in
            
            AppInstance.showMessages(message: error.localizedDescription)
            
        })
    }
    
    func APIAllProdcutList() {
        
        let param : [String:Any] = ["UserId":kCurrentUser.UserId,
                                    "Category": "",
                                    "Subcategory": "",
                                    "MinPrice": "",
                                    "MaxPrice": "",
                                    //                                        "SearchKeyWord" : "free",
                                    "PageId": 0,
                                    "PerPage": 300,
                                    "Sort":1,
                                    "Distance": 10000]
        
        AlamofireModel.alamofireMethod(.post, apiAction: .AllProdcutList, parameters: param, Header: [:], handler:{res in
            
            if res.success == 1
            {
                
                guard let productJSONData = JSON(res.json).array?.first?.dictionaryValue["ProductData"] else {
                    return
                }
                
                
                productlist = ProductList()
                productlist.update(productJSONData)
                
                self.filterProductByProductType = productlist.productdetail.filter({ $0.ProductType == "1" })
                self.lblSellCounts.text = self.filterProductByProductType.count.description
                self.lblFreeCount.text = productlist.productdetail.filter({ $0.ProductType == "2" }).count.description
                self.lblRequestCount.text = productlist.productdetail.filter({ $0.ProductType == "3" }).count.description
                self.productsCLNView.reloadData()
                
                self.view.layoutIfNeeded()
                //                    self.productCLNViewHeights.constant = 3000
                self.productCLNViewHeights.constant = self.productsCLNView.contentSize.height
                self.productsCLNView.reloadData()
                
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

