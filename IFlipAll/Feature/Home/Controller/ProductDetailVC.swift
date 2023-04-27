//
//  ProductDetailVC.swift
//  IFlipAll
//
//  Created by kishan on 29/11/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit
import MapKit

class ProductDetailVC: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var clnViewProductDetailImg: UICollectionView!
    @IBOutlet weak var imgProductPic: UIImageView!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblUserSince: UILabel!
    @IBOutlet weak var lblAvailability: UILabel!
    @IBOutlet weak var availabilityView: UIView!
    @IBOutlet weak var priceView: UIView!
    
    @IBOutlet weak var likeView: UIView!
    @IBOutlet weak var reportView: UIView!
    @IBOutlet weak var shareView: UIView!
    
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnReport: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnChat: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var productDetail = ProductDetail()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.availabilityView.layer.cornerRadius = 14.0
            self.likeView.layer.cornerRadius = 5.0
            self.reportView.layer.cornerRadius = 5.0
            self.shareView.layer.cornerRadius = 5.0
            self.btnChat.layer.cornerRadius = 5.0
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.clnViewProductDetailImg.reloadData()
        
        if self.productDetail.Images.count > 0, self.productDetail.Images[0] != "" {
            self.imgProductPic.sd_setImage(with: URL(string: self.productDetail.Images[0]), placeholderImage: UIImage(named: "ic_placeHolder"))
        }
        
        let temp = self.productDetail
        let productPrice = temp.ProductType == "1" ? "$" + temp.Price : temp.ProductType == "2" ? "" : "Expected $\(temp.Price)"
        lblProductPrice.text = productPrice
        priceView.isHidden = temp.ProductType == "2"
        lblUserSince.text = "Member since \(temp.UserSince)"
        lblProductName.text = temp.Name
        imgUserProfile.sd_setImage(with: URL(string: temp.UserProfile), placeholderImage: UIImage(named: "ic_placeHolder"))
        lblUserName.text = temp.UserName
        lblDescription.text = temp.Description
        // Product Type => 1:(Sell), 2:(Free), 3:(Request)
        lblAvailability.text = temp.ProductType == "1" ? "Available" : temp.ProductType == "2" ? "Free" : "Request"
    
        btnLike.isSelected = temp.ProductSave == "0"
        btnReport.isSelected = temp.ProductSave == "0"
        
        
        let span = MKCoordinateSpan.init(latitudeDelta: 0.01, longitudeDelta:0.01)
        let coordinate = CLLocationCoordinate2D.init(latitude: Double(temp.Langitude) ?? 0.0, longitude: Double(temp.Longitude) ?? 0.0)
        let region = MKCoordinateRegion.init(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        mapView.delegate = self
        let circle = MKCircle(center: coordinate, radius: CLLocationDistance(300.0))
        mapView.addOverlay(circle)
        
        self.btnDelete.isHidden = kCurrentUser.UserId != self.productDetail.UserId
        self.btnChat.isHidden = kCurrentUser.UserId == self.productDetail.UserId
    }
    
    // MKMapViewDelegate
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.strokeColor = appColors.purpleColor
        circleRenderer.fillColor = appColors.green.withAlphaComponent(0.5)
        circleRenderer.lineWidth = 1.0
        return circleRenderer
    }

    
    private func shareProduct() {
        
        let text = productDetail.CategoryName
        let description = productDetail.Description
        
        let imageData = URL(string: self.productDetail.Images.first ?? "")?.dataRepresentation
        // set up activity view controller
        let activityItems = [ text, description, imageData ?? Data() ] as [Any]
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
//        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)

    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnChatAction(_ sender: UIButton) {
        let resultVC : ChatVC = Utilities.viewController(name: "ChatVC", storyboard: "MyProfile") as! ChatVC
        resultVC.to_user_id = self.productDetail.UserId
        resultVC.to_user_name = self.productDetail.UserName
        resultVC.to_user_image = self.productDetail.UserProfile
        self.navigationController?.pushViewController(resultVC, animated: true)
    }
    
    @IBAction func btnDeleteAction(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "", message: "Are you sure you want to delete?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default) { action in
        })
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { action in
            self.apiDeleteProduct()
        })
        
        self.present(alert, animated: true, completion: nil)
        
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
    
    @IBAction func btnLikeAction(_ sender: UIButton) {
        productLikeAPICall(productSave: productDetail.ProductSave == "0" ? 1 : 0)
    }
    
    @IBAction func btnReportAction(_ sender: UIButton) {
        if sender.isSelected == true {
            // show alert that it is already reported
            AppInstance.showMessages(message: "You are already reported this product.")
        } else {
            reportAPICall()
        }
    }
    
    @IBAction func btnShareAction(_ sender: UIButton) {
        shareProduct()
    }
    
}

extension ProductDetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.productDetail.Images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
         let cell: ProductDetailCLNCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductDetailCLNCell", for: indexPath) as! ProductDetailCLNCell
        
            cell.imgProductDetail.sd_setImage(with: URL(string: self.productDetail.Images[indexPath.row]), placeholderImage: UIImage(named: "ic_placeHolder"))
        
  
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        imgProductPic.sd_setImage(with: URL(string: self.productDetail.Images[indexPath.row]), placeholderImage: UIImage(named: "ic_placeHolder"))
    }
}

extension ProductDetailVC {
    
    // Product Like and unlike api
    func productLikeAPICall(productSave: Int) {
        let param : [String:Any] = ["UserId":Int(kCurrentUser.UserId) ?? 0,
                                    "ProductId": Int(productDetail.Id) ?? 0,
                                    "SaveValue": productSave]

        AlamofireModel.alamofireMethod(.post, apiAction: .SaveProduct, parameters: param, Header: [:], handler:{res in

            if res.success == 1
            {
                self.productDetail.ProductSave = "\(productSave)"
                self.btnLike.isSelected = productSave == 0
            }
            else
            {
                AppInstance.showMessages(message: res.message)
            }
           

        }, errorhandler: {error in

            AppInstance.showMessages(message: error.localizedDescription)

        })
    }
    
    func reportAPICall() {
        let param : [String:Any] = ["UserId":Int(kCurrentUser.UserId) ?? 0,
                                    "ProductId": Int(productDetail.Id) ?? 0,
                                    "SaveValue": 0]

        AlamofireModel.alamofireMethod(.post, apiAction: .ReportProduct, parameters: param, Header: [:], handler:{res in

            if res.success == 1
            {
                self.btnReport.isSelected = true
            }
            else
            {
                AppInstance.showMessages(message: res.message)
            }
           

        }, errorhandler: {error in

            AppInstance.showMessages(message: error.localizedDescription)

        })
    }
    
    func apiDeleteProduct() {
        let param : [String:Any] = ["UserId": kCurrentUser.UserId,
                                    "ProductId": self.productDetail.Id]

        AlamofireModel.alamofireMethod(.post, apiAction: .DeleteProduct, parameters: param, Header: [:], handler:{res in

            if res.success == 1
            {
                self.navigationController?.popViewController(animated: true)
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
