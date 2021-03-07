//
//  ChangePasswordVC.swift
//  IFlipAll
//
//  Created by kishan on 28/11/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit

class ChangePasswordVC: UIViewController {
    
    @IBOutlet weak var txtOldPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtConfirmNewPassword: UITextField!
    
    @IBOutlet weak var imgshowOldPassword: UIImageView!
    @IBOutlet weak var imgshowNewPassword: UIImageView!
    @IBOutlet weak var imgshowConfirmNewPassword: UIImageView!
    
    var showOldPassword = true
    var showNewPassword = true
    var showConfirmNewPassword = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
           self.navigationController?.popViewController(animated: true)
       }
    
    @IBAction func btnResetPasswordAction(_ sender: UIButton) {
        
        if validation()
        {
            self.APIChangePassword()
        }
    }
    
    @IBAction func btnshowOldPasswordAction(_ sender: UIButton) {
        if(showOldPassword == true)
        {
            txtOldPassword.isSecureTextEntry = false
            self.imgshowOldPassword.image = UIImage(named: "ic_eye_close")
        } else {
            txtOldPassword.isSecureTextEntry = true
            self.imgshowOldPassword.image = UIImage(named: "ic_eye")
        }

        showOldPassword = !showOldPassword
    }
    
    @IBAction func btnshowNewPasswordAction(_ sender: UIButton) {
        if(showNewPassword == true)
        {
            txtNewPassword.isSecureTextEntry = false
            self.imgshowNewPassword.image = UIImage(named: "ic_eye_close")
        } else {
            txtNewPassword.isSecureTextEntry = true
            self.imgshowNewPassword.image = UIImage(named: "ic_eye")
        }

        showNewPassword = !showNewPassword
    }
    
    @IBAction func btnshowConfirmNewPasswordAction(_ sender: UIButton) {
        if(showConfirmNewPassword == true)
        {
            txtConfirmNewPassword.isSecureTextEntry = false
            self.imgshowConfirmNewPassword.image = UIImage(named: "ic_eye_close")
        } else {
            txtConfirmNewPassword.isSecureTextEntry = true
            self.imgshowConfirmNewPassword.image = UIImage(named: "ic_eye")
        }

        showConfirmNewPassword = !showConfirmNewPassword
    }
    
    func validation() -> Bool
         {
             self.txtOldPassword.text = Utilities.trim(self.txtOldPassword.text!)
             self.txtNewPassword.text = Utilities.trim(self.txtNewPassword.text!)
             self.txtConfirmNewPassword.text = Utilities.trim(self.txtConfirmNewPassword.text!)
             
             if self.txtOldPassword.text == ""
             {
                AppInstance.showMessages(message: appString.empty_old_password_msg)
             }
             else if self.txtNewPassword.text == ""
             {
                 AppInstance.showMessages(message: appString.empty_new_password_msg)
             }
             else if self.txtConfirmNewPassword.text == ""
             {
                 AppInstance.showMessages(message: appString.empty_confirm_password_msg)
             }
             else if self.txtNewPassword.text !=  self.txtConfirmNewPassword.text
             {
                 AppInstance.showMessages(message: appString.new_password_and_confirm_password_does_not_match)
             }
             else
             {
                 return true
             }
             
             return false
         }
    
}

extension ChangePasswordVC
{
    func APIChangePassword()
    {
     
        let param : [String:Any] = ["UserId":kCurrentUser.UserId,
                                    "OldPassword":self.txtOldPassword.text!,
                                    "NewPassword":self.txtNewPassword.text!]

        AlamofireModel.alamofireMethod(.post, apiAction: .ChangePassword, parameters: param, Header: [:], handler:{res in

            if res.success == 1
            {
                self.navigationController?.popViewController(animated: true)
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

