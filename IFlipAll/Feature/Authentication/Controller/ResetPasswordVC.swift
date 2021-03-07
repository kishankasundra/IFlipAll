//
//  ResetPasswordVC.swift
//  IFlipAll
//
//  Created by kishan on 25/12/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit

class ResetPasswordVC: UIViewController {
    
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var txtOTP: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    
    var email = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.lblEmail.text = self.email
        
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSubmitAction(_ sender: UIButton) {
        
        if validation()
        {
            self.APIResetPassword()
        }
    }
    
    @IBAction func btnResetCodeAction(_ sender: UIButton) {
        
        self.APIReSendOTP()
        
    }
    
    func validation() -> Bool
    {
        self.txtOTP.text = Utilities.trim(self.txtOTP.text!)
        self.txtNewPassword.text = Utilities.trim(self.txtNewPassword.text!)
        
        if self.txtOTP.text == ""
        {
            AppInstance.showMessages(message: "Enter your otp")
        }
        else if self.txtOTP.text != otpdata.otpdetail[0].OTP
        {
            AppInstance.showMessages(message: "Please enter valid otp")
        }
        else if self.txtNewPassword.text == ""
        {
            AppInstance.showMessages(message: appString.empty_new_password_msg)
        }
        else
        {
            return true
        }
        
        return false
        
    }
    
}

extension ResetPasswordVC
{
    func APIReSendOTP()
    {
     
        let param : [String:Any] = ["Email":self.lblEmail.text!]

        AlamofireModel.alamofireMethod(.post, apiAction: .SendOTP, parameters: param, Header: [:], handler:{res in

            if res.success == 1
            {
                otpdata = OTPData()
                otpdata.update(res.json)
            }
            else
            {
                AppInstance.showMessages(message: res.message)
            }
           

        }, errorhandler: {error in

            AppInstance.showMessages(message: error.localizedDescription)

        })
    }
    
    func APIResetPassword()
       {
        
        let param : [String:Any] = ["UserId":otpdata.otpdetail[0].UserId,
                                    "Password":self.txtNewPassword.text!]

           AlamofireModel.alamofireMethod(.post, apiAction: .ResetPassword, parameters: param, Header: [:], handler:{res in

               if res.success == 1
               {
                   let resultVC : LoginVC = Utilities.viewController(name: "LoginVC", storyboard: "Authentication") as! LoginVC
                   self.navigationController?.pushViewController(resultVC, animated: true)
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
