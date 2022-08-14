//
//  PostAnItemTabVC.swift
//  IFlipAll
//
//  Created by kishan on 29/11/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit
import StoreKit
import DropDown
import GoogleMaps
import GooglePlaces

class PostAnItemTabVC: UIViewController {
    
    @IBOutlet weak var txtProductTitle: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtCategory: UITextField!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var imgRadioOn: UIImageView!
    @IBOutlet weak var imgRadioOff: UIImageView!
    
    @IBOutlet weak var clnView: UICollectionView!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    var isForEdit: Bool = false
    var productCondition = ""
    let placeHolderText = "Write here"
    
    var myProductDetail = MyProductDetail()
    var selectedCategory = CategoryDetail()
    
    var selectedImages = [UIImage]()
    var imgURLs: [String] = [String]()
    var imagePicker = UIImagePickerController()
    var isImageChangedProfile : Bool = false
    var imageDict : [[String:String]] =  [[String:String]]()
    var lat: Double = 0.0
    var lng: Double = 0.0
    var address: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
  
        txtDescription.delegate = self
        self.txtDescription.text = placeHolderText
        
        if isForEdit
        {
            btnSave.setTitle("Save", for: .normal)
            btnCancel.setTitle("Delete Product", for: .normal)
            imgBack.isHidden = false
            btnBack.isHidden = false
        }
        else
        {
            btnSave.setTitle("Upload & Post", for: .normal)
            btnCancel.setTitle("Cancel", for: .normal)
            imgBack.isHidden = true
            btnBack.isHidden = true
        }
        
        if isForEdit
        {
            self.txtProductTitle.text = self.myProductDetail.Name
            self.txtPrice.text = "Rs." + self.myProductDetail.Price
            self.txtCategory.text = self.myProductDetail.CategoryName
            self.txtDescription.text = self.myProductDetail.Description
            self.txtAddress.text = self.myProductDetail.Address
            
            if self.myProductDetail.Condition == "new"
            {
                self.imgRadioOn.image = UIImage(named: "ic_radio_on")
                self.imgRadioOff.image = UIImage(named: "ic_radio_off")
                self.productCondition = "New"
            }
            else if self.myProductDetail.Condition == "old"
            {
                self.imgRadioOn.image = UIImage(named: "ic_radio_off")
                self.imgRadioOff.image = UIImage(named: "ic_radio_on")
                self.productCondition = "Old"
            }
            else
            {
                self.imgRadioOn.image = UIImage(named: "ic_radio_off")
                self.imgRadioOff.image = UIImage(named: "ic_radio_off")

            }
            
//            for obj in self.myProductDetail.Images
//            {
//                let temp = obj.toImage()
//
//                if temp != nil
//                {
//                    self.selectedImages.append(temp!)
//                }
//
//                print(obj)
//                print(temp?.description)
//                self.clnView.reloadData()
//            }
            
            for obj in self.myProductDetail.Images
            {
                //let imageUrlString = obj

                let imageUrl = URL(string: obj)!

                let imageData = try! Data(contentsOf: imageUrl)

                let image = UIImage(data: imageData)
                
                if image != nil
                {
                    self.selectedImages.append(image!)
                    let firstImage: [String:String] = ["url":obj]
                    self.imageDict.append(firstImage)
                }
                
            }
            
            clnView.reloadData()

        }

    }
        
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnRadioOnAction(_ sender: UIButton) {
        self.imgRadioOn.image = UIImage(named: "ic_radio_on")
        self.imgRadioOff.image = UIImage(named: "ic_radio_off")
        self.productCondition = "New"
    }
    
    @IBAction func btnRadioOffAction(_ sender: UIButton) {
        self.imgRadioOn.image = UIImage(named: "ic_radio_off")
        self.imgRadioOff.image = UIImage(named: "ic_radio_on")
        self.productCondition = "Old"
    }
    
    @IBAction func btnTackPhoto(_ sender: UIButton) {
        
        if self.selectedImages.count > 3 {
                AppInstance.showMessages(message: "You can upload maximum 4 image")
            } else {
                self.pickPhoto()
            }
            
    }
    
    @IBAction func btnCategoryDropDownAction(_ sender: UIButton) {
        
        let dropDown = DropDown()
        dropDown.anchorView = sender
        dropDown.width = sender.frame.width
        dropDown.backgroundColor = .white
        dropDown.shadowColor = appColors.black1
        dropDown.dataSource = categorylist.detail.map({$0.CategoryName})
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            self.txtCategory.text = item
            self.selectedCategory = categorylist.detail[index]
        }
        dropDown.show()
        
    }
    
    @IBAction func btnSelectAdressAction(_ sender: UIButton) {
        let autoCompletController = GMSAutocompleteViewController()
        let filter = GMSAutocompleteFilter()
        filter.type = .region
        autoCompletController.autocompleteFilter = filter
        autoCompletController.delegate = self
        self.present(autoCompletController, animated: true, completion: nil)
    }
    
    @IBAction func btnCancelAction(_ sender: UIButton) {
        if isForEdit
        {
            let resultVC : DeletePostPopUpVC = Utilities.viewController(name: "DeletePostPopUpVC", storyboard: "MyProfile") as! DeletePostPopUpVC
            self.present(resultVC, animated: false, completion: nil)
        }
        else
        {
           //self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    @IBAction func btnUploadAnPostAction(_ sender: UIButton) {
        
        if validation()
        {
            self.UpladtImagesAndCallAPI()
        }
            
    }
    
    func validation() -> Bool
    {
        self.txtProductTitle.text = Utilities.trim(self.txtProductTitle.text!)
        self.txtPrice.text = Utilities.trim(self.txtPrice.text!)
        self.txtDescription.text = Utilities.trim(self.txtDescription.text!)
        
        if self.selectedImages.count < 1 {
            AppInstance.showMessages(message:appString.empty_image_msg)
        }
        else if self.txtProductTitle.text == ""
        {
            AppInstance.showMessages(message: appString.empty_product_title_msg)
        }
        else if self.selectedCategory.CatId == ""
        {
            AppInstance.showMessages(message: appString.empty_product_category)
        }
        else if self.txtPrice.text == ""
        {
            AppInstance.showMessages(message: appString.empty_price_msg)
        }
        else if self.productCondition == ""
        {
            AppInstance.showMessages(message: appString.empty_product_condition_msg)
        }
        else if self.txtDescription.text == "Write here" || self.txtDescription.text == ""
        {
            AppInstance.showMessages(message: appString.empty_description_msg)
        }
        else if self.address == "" {
            AppInstance.showMessages(message: appString.empty_address_msg)
        }
        else
        {
            return true
        }
        
        return false
        
    }
    
    func UpladtImagesAndCallAPI() {
        
        
        if self.selectedImages.count > 0 {
            
            AWSS3Manager.shared.uploadImage(image: self.selectedImages[0], progress: {progress in
                print("Image Upload Progress", progress)
            }, completion: {(res, error) in
            
                if res != nil, let url = res as? String {
                    self.selectedImages.remove(at: 0)
                    self.imgURLs.append(url)
                    self.UpladtImagesAndCallAPI()
                } else {
                    AppInstance.showMessages(message: error?.localizedDescription ?? "Error in image upload")
                }
            
            
            })
            
        } else {
            self.APIAddProduct()
        }
    }
    
}

extension PostAnItemTabVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.txtDescription.text  == self.placeHolderText {
            self.txtDescription.text = ""
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.txtDescription.text  == "" {
            self.txtDescription.text = self.placeHolderText
        }
    }
    
    
}

extension PostAnItemTabVC: GMSAutocompleteViewControllerDelegate
{
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        self.lat = place.coordinate.latitude
        self.lng = place.coordinate.longitude
        self.address = place.formattedAddress ?? ""
        self.txtAddress.text = self.address
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        
        print("ERROR AUTO COMPLETE \(error)")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }

}

extension PostAnItemTabVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func pickPhoto()
    {
        imagePicker.delegate = self
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = self.clnView
            alert.popoverPresentationController?.sourceRect = self.clnView.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .down
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            AppInstance.showMessages(message: "You don't have camera")
        }
    }
    
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        {
            let img = Utilities.resizeImage(image: image)
            self.selectedImages.append(img)
            self.isImageChangedProfile = true

            self.clnView.reloadData()
            
        }
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
}

extension PostAnItemTabVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectedImages.count // + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
         let cell: PostAnItemCLNCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostAnItemCLNCell", for: indexPath) as! PostAnItemCLNCell
        cell.imgAddIcone.image = self.selectedImages[indexPath.row]
        cell.btnClose.tag = indexPath.row
        cell.btnClose.addTarget(self, action: #selector(btnDeleteImgAction), for: .touchUpInside)
        return cell
    }
    
    @objc func btnDeleteImgAction(_ sender: UIButton) {
           if self.selectedImages.count > sender.tag
           {
               self.selectedImages.remove(at: sender.tag)
               
               if self.imageDict.count > sender.tag
               {
                self.imageDict.remove(at: sender.tag)
               }
            
               self.clnView.reloadData()
           }
       }
    
    
}

extension PostAnItemTabVC {
    
    func APIAddProduct() {
        
        var imgDicts:  [[String:String]] = [[String:String]]()
        
        for obj in self.imgURLs {
            let temp = ["url": obj]
            imgDicts.append(temp)
        }
        
  
        let params: [String: Any] = ["CategoryId":self.selectedCategory.CatId,
                                     "UserId": kCurrentUser.UserId,
                                     "Name": self.txtProductTitle.text!,
                                     "Price": self.txtPrice.text!,
                                     "Description":self.txtDescription.text!,
                                     "Condition": self.productCondition,
                                     "Images": JSON(imgDicts),
                                     "Longitude":self.lng,
                                     "Langitude":self.lat,
                                     "Address": self.address,
                                     "Negotiation": "false",
                                     "product_type": 2,//self.isProdRequest ? 1 : 2,
                                     "ProductId": self.myProductDetail.Id,
                                     "SoldStatus": "1"
        ]
        
        print(params)
        
        AlamofireModel.alamofireMethod(.post, apiAction: self.isForEdit ? .EditProduct : .AddProduct, parameters: params, Header: [:], handler: {res in
            
            if res.success == 1 {
                AppInstance?.goToHomeVC()
            }
            
            AppInstance.showMessages(message: res.message)
            
             
        }, errorhandler: {error in
            AppInstance.showMessages(message: error.localizedDescription)
        })
    }
    
}
