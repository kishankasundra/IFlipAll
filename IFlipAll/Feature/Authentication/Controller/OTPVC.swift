//
//  OTPVC.swift
//  IFlipAll
//
//  Created by kishan on 29/11/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit

class OTPVC: UIViewController {
    
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var txtOTP: UITextField!
    
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
            let resultVC : VerifyEmailVC = Utilities.viewController(name: "VerifyEmailVC", storyboard: "Authentication") as! VerifyEmailVC
            self.navigationController?.pushViewController(resultVC, animated: true)
        }
        

    }
    
    @IBAction func btnResetCodeAction(_ sender: UIButton) {
        
        self.APIReSendOTP()
        
    }
    
    func validation() -> Bool
           {
               self.txtOTP.text = Utilities.trim(self.txtOTP.text!)
               
               if self.txtOTP.text == ""
               {
                   AppInstance.showMessages(message: "Enter your otp")
               }
               else if self.txtOTP.text != otpdata.otpdetail[0].OTP
               {
                   AppInstance.showMessages(message: "Please enter valid otp")
               }
               else
               {
                   return true
               }
               
               return false
               
           }
 
}

extension OTPVC
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
    
    
}
