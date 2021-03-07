//
//  VerifyEmailVC.swift
//  IFlipAll
//
//  Created by kishan on 29/11/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit

class VerifyEmailVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
           self.navigationController?.popViewController(animated: true)
       }
    
    @IBAction func btnOkAction(_ sender: UIButton) {
       
        self.APIVerifyEmail()
        
    }
    
}

extension VerifyEmailVC
{
    func APIVerifyEmail()
    {
     
        let param : [String:Any] = ["UserId":kCurrentUser.UserId]

        AlamofireModel.alamofireMethod(.post, apiAction: .VerifyEmail, parameters: param, Header: [:], handler:{res in

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
