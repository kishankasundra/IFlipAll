//
//  EditProfileVC.swift
//  IFlipAll
//
//  Created by kishan on 28/11/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit

class EditProfileVC: UIViewController {

    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    
    var imagePicker = UIImagePickerController()
    var isImageChangedProfile : Bool = false
    
    var imgUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.txtPhone.isEnabled = false
        self.txtEmail.isEnabled = false
        
        self.updateUserData()
        
        if kCurrentUser.PhoneNumber == "" || kCurrentUser.PhoneNumber == "0"
        {
            self.txtPhone.isEnabled = true
        }
            
        if kCurrentUser.Email == ""
        {
            self.txtEmail.isEnabled = true
        }
        
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSaveAction(_ sender: UIButton) {
        
        if validation()
        {
            if self.isImageChangedProfile {
                AWSS3Manager.shared.uploadImage(image: self.imgUserProfile.image!, progress: {progress in
                    
                    print("Image Upload Progress", progress)
                }, completion: {(res, error) in

                    if res != nil, let url = res as? String {
                       
                        self.imgUrl = url
                        print(self.imgUrl)
                        self.APIChangeProfile()
                        
                    } else {
                        AppInstance.showMessages(message: error?.localizedDescription ?? "Error in image upload")
                    }


                })
                
            }
            else
            {
                self.APIChangeProfile()
            }
            
        }
        
    }
    
    @IBAction func btnChangeProfileAction(_ sender: UIButton) {
        self.pickPhoto()
    }
    
    func validation() -> Bool
       {
           self.txtFullName.text = Utilities.trim(self.txtFullName.text!)
           self.txtEmail.text = Utilities.trim(self.txtEmail.text!)
           self.txtPhone.text = Utilities.trim(self.txtPhone.text!)
           
//           if self.imgUrl == "" {
//               AppInstance.showMessages(message:appString.empty_image_msg)
//           }
           if self.txtFullName.text == ""
           {
               AppInstance.showMessages(message: appString.empty_full_name_msg)
           }
           else if self.txtEmail.text == ""
           {
               AppInstance.showMessages(message: appString.empty_full_name_msg)
           }
           else if !Utilities.isValidEmail(self.txtEmail.text!)
           {
               AppInstance.showMessages(message: appString.invalid_email_msg)
           }
           else if self.txtPhone.text == ""
           {
               AppInstance.showMessages(message: appString.empty_full_name_msg)
           }
           else if !Utilities.isValidContactNumber(self.txtPhone.text!)
           {
               AppInstance.showMessages(message: appString.invalid_mobile_msg)
           }
           else
           {
               return true
           }
           
           return false
    }
    
    func updateUserData()
    {
        self.imgUserProfile.sd_setImage(with: URL(string: kCurrentUser.ProfileImage), placeholderImage: UIImage(named: "ic_default_profile"))
        self.txtFullName.text = kCurrentUser.FullName
        self.txtEmail.text = kCurrentUser.Email
        self.txtPhone.text = kCurrentUser.PhoneNumber
    }
    
}

extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
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
            alert.popoverPresentationController?.sourceView = self.imgUserProfile
            alert.popoverPresentationController?.sourceRect = self.imgUserProfile.bounds
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
            //self.selectedImages.append(img)
            self.imgUserProfile.image = img
            self.isImageChangedProfile = true
                        
        }
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
}

extension EditProfileVC
{
    func APIChangeProfile()
    {
     
        var param : [String:Any] = [:]
        
        if isImageChangedProfile == true
        {
                              param  = ["UserId":kCurrentUser.UserId,
                                        "FullName":self.txtFullName.text!,
                                        "PhNo":self.txtPhone.text!,
                                        "CountryCode":"+1",
                                        "Email":self.txtEmail.text!,
                                        "ProfileImage":self.imgUrl]
        }
        else
        {
                              param  = ["UserId":kCurrentUser.UserId,
                                        "FullName":self.txtFullName.text!,
                                        "PhNo":self.txtPhone.text!,
                                        "CountryCode":"+1",
                                        "Email":self.txtEmail.text!,
                                        "ProfileImage":kCurrentUser.ProfileImage]
        }
        
        AlamofireModel.alamofireMethod(.post, apiAction: .ChangeProfile, parameters: param, Header: [:], handler:{res in

            if res.success == 1
            {
                kCurrentUser.FullName = self.txtFullName.text!
                kCurrentUser.PhoneNumber = self.txtPhone.text!
                kCurrentUser.CountryCode = "+1"
                kCurrentUser.Email = self.txtEmail.text!
                if self.isImageChangedProfile == true
                {
                    kCurrentUser.ProfileImage = self.imgUrl
                }
                
                
                if isFromSocial == true
                {
                    let resultVC : HomeVC = Utilities.viewController(name: "HomeVC", storyboard: "Home") as! HomeVC
                    self.navigationController?.pushViewController(resultVC, animated: true)
                }
                else
                {
                    kCurrentUser.saveToDefault()
                    self.navigationController?.popViewController(animated: true)
                }
                
                AppInstance.showMessages(message: res.message)
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

//if phone no 0 or empty then edit
//email empty 
