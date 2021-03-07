//
//  ForgotPasswordVC.swift
//  IFlipAll
//
//  Created by kishan on 29/11/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController {
    
    @IBOutlet weak var txtEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
           self.navigationController?.popViewController(animated: true)
       }
    
    @IBAction func btnSubmitAction(_ sender: UIButton) {
        
        if validation()
        {
            self.APISendOTP()
        }
    }
    
    func validation() -> Bool
           {
               self.txtEmail.text = Utilities.trim(self.txtEmail.text!)
              
               if self.txtEmail.text == ""
               {
                   AppInstance.showMessages(message: appString.empty_email_msg)
               }
               else if !Utilities.isValidEmail(self.txtEmail.text!)
               {
                   AppInstance.showMessages(message: appString.invalid_email_msg)
               }
               else
               {
                   return true
               }
               
               return false
               
           }
           

}

extension ForgotPasswordVC
{
    func APISendOTP()
    {
     
        let param : [String:Any] = ["Email":self.txtEmail.text!]

        AlamofireModel.alamofireMethod(.post, apiAction: .SendOTP, parameters: param, Header: [:], handler:{res in

            if res.success == 1
            {
                otpdata = OTPData()
                otpdata.update(res.json)
                let resultVC : ResetPasswordVC = Utilities.viewController(name: "ResetPasswordVC", storyboard: "Authentication") as! ResetPasswordVC
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
