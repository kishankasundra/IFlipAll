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
    
    var isEdit = ""
    var productCondition = ""
    let placeHolderText = "Write here"
    
    var myProductDetail = MyProductDetail()
    
    var selectedImages = [UIImage]()
    var imagePicker = UIImagePickerController()
    var isImageChangedProfile : Bool = false
    var imageDict : [[String:String]] =  [[String:String]]()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
  
        txtDescription.delegate = self
        self.txtDescription.text = placeHolderText
        
        if isEdit == "Edit"
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
        
        if isEdit == "Edit"
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
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCancelAction(_ sender: UIButton) {
        if isEdit == "Edit"
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

            if self.selectedImages.count != imageDict.count
            {
                imageDict =  [[String:String]]()
                
                for img in selectedImages
                {
                    
                    
                    AWSS3Manager.shared.uploadImage(image: img, progress: {progress in
                        
                            print("Image Upload Progress", progress)
                        }, completion: {(res, error) in

                            if res != nil, let url = res as? String {
                               
                             let firstImage: [String:String] = ["url":url]
                             self.imageDict.append(firstImage)

                                if self.selectedImages.count == self.imageDict.count
                                {
                                       print(self.selectedImages.count)
                                       print(self.imageDict.count)
                                       print(self.imageDict.count)
                                       
                                    //self.APIChangeProfile()
                                }

                        
                            } else {
                                AppInstance.showMessages(message: error?.localizedDescription ?? "Error in image upload")
                            }


                        })
                }
            }
            else
            {
                if self.selectedImages.count == self.imageDict.count
                {
                       print(self.selectedImages.count)
                       print(self.imageDict.count)
                       print(self.imageDict.count)
                       
                    //self.APIChangeProfile()
                }
            }
            
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
        else
        {
            return true
        }
        
        return false
        
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
