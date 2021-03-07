//
//  RegisterVC.swift
//  IFlipAll
//
//  Created by kishan on 29/11/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {

    @IBOutlet weak var txtFullname: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var imgAcceptTermsAndService: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imgAcceptTermsAndService.isHidden = true
        
    }
    
    @IBAction func btnAcceptTermsAndServiceAction(_ sender: UIButton) {
        
        if self.imgAcceptTermsAndService.isHidden == true
        {
            self.imgAcceptTermsAndService.isHidden = false
        }
        else
        {
            self.imgAcceptTermsAndService.isHidden = true
        }
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
           self.navigationController?.popViewController(animated: true)
       }
    
    @IBAction func btnSignUpAction(_ sender: UIButton) {
        
       if validation()
       {
        self.APISignUp()
       }

    }
    
    @IBAction func btnSignInAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
     func validation() -> Bool
        {
            self.txtFullname.text = Utilities.trim(self.txtFullname.text!)
            self.txtEmail.text = Utilities.trim(self.txtEmail.text!)
            self.txtMobile.text = Utilities.trim(self.txtMobile.text!)
            self.txtPassword.text = Utilities.trim(self.txtPassword.text!)
            
            if self.txtFullname.text == ""
            {
                AppInstance.showMessages(message: appString.empty_full_name_msg)
            }
            else if self.txtEmail.text == ""
            {
                AppInstance.showMessages(message: appString.empty_email_msg)
            }
            else if !Utilities.isValidEmail(self.txtEmail.text!)
            {
                AppInstance.showMessages(message: appString.invalid_email_msg)
            }
            else if self.txtMobile.text == ""
            {
                AppInstance.showMessages(message: appString.empty_mobile_msg)
            }
            else if !Utilities.isValidContactNumber(self.txtMobile.text!)
            {
                AppInstance.showMessages(message: appString.invalid_mobile_msg)
            }
            else if self.txtPassword.text == ""
            {
                AppInstance.showMessages(message: appString.empty_password_msg)
            }
            else if self.imgAcceptTermsAndService.isHidden == true
            {
                AppInstance.showMessages(message: appString.unselect_terms_msg)
            }
            else
            {
                return true
            }
            
            return false
            
        }
        
    }

    extension RegisterVC
    {
        func APISignUp()
        {
         
            let param : [String:Any] = ["FullName":self.txtFullname.text!,
                                        "Email":self.txtEmail.text!,
                                        "PhNo":self.txtMobile.text!,
                                        "Password":self.txtPassword.text!,
                                        "CountryCode":"+1"]

            AlamofireModel.alamofireMethod(.post, apiAction: .SignUp, parameters: param, Header: [:], handler:{res in

                if res.success == 1
                {
                    kCurrentUser.update(res.json[0])
                    
                    print(kCurrentUser.FullName)
                    
                    self.APISendOTP()
                    
                }
                else
                {
                    AppInstance.showMessages(message: res.message)
                }
               

            }, errorhandler: {error in

                AppInstance.showMessages(message: error.localizedDescription)

            })
        }
        
        func APISendOTP()
           {
            
               let param : [String:Any] = ["Email":self.txtEmail.text!]

               AlamofireModel.alamofireMethod(.post, apiAction: .SendOTP, parameters: param, Header: [:], handler:{res in

                   if res.success == 1
                   {
                       
                       otpdata = OTPData()
                       otpdata.update(res.json)
                    
                       let resultVC : OTPVC = Utilities.viewController(name: "OTPVC", storyboard: "Authentication") as! OTPVC
                       resultVC.email = self.txtEmail.text!
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

    

