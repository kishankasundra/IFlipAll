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
    
    @IBOutlet weak var lblFreeCounts: UILabel!
    @IBOutlet weak var lblNeedCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = productsCLNView?.collectionViewLayout as? PinterestLayout {
          layout.delegate = self
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//                self.view.layoutIfNeeded()
//                self.productCLNViewHeights.constant = 3000
//                self.productCLNViewHeights.constant = self.productsCLNView.contentSize.height
//                productsCLNView.reloadData()
                
                self.APICategoryList()
                self.APIAllProdcutList()
        
    }
    
    @IBAction func btnFreeAction(_ sender: UIButton) {
    }
    
    @IBAction func btnNeedAction(_ sender: UIButton) {
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
            return productlist.productdetail.count
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
            
            let temp = productlist.productdetail[indexPath.row]
            if temp.Images.count > 0 && temp.Images[0] != ""
            {
                let temp = productlist.productdetail[indexPath.row].Images[0]
                cell.imgProductList.sd_setImage(with: URL(string: temp), placeholderImage:UIImage(named: "ic_home_top_bg"))
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
            resultVC.productDetail = productlist.productdetail[indexPath.row]
            self.navigationController?.pushViewController(resultVC, animated: true)
         }

    }
        
}

extension HomeTabVC: PinterestLayoutDelegate {
  func collectionView(
      _ collectionView: UICollectionView,
      heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
    let width = (ScreenWidth-4)/3
    return (width * self.ratio[indexPath.row])
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
                    categorylist = CategoryList()
                    categorylist.update(res.json)
                    self.categoryCLNView.reloadData()
                    
                }
                else
                {
                    AppInstance.showMessages(message: res.message)
                }
               

            }, errorhandler: {error in

                AppInstance.showMessages(message: error.localizedDescription)

            })
        }
        
        func APIAllProdcutList()
        {
         
            let param : [String:Any] = [:]

            AlamofireModel.alamofireMethod(.post, apiAction: .AllProdcutList, parameters: param, Header: [:], handler:{res in

                if res.success == 1
                {
                    productlist = ProductList()
                    productlist.update(res.json)
                    
                    self.lblFreeCounts.text = productlist.productdetail.count.description
                    
                    self.productsCLNView.reloadData()
                    
                    self.view.layoutIfNeeded()
                    self.productCLNViewHeights.constant = 3000
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

