//
//  TermsAndConditionsVC.swift
//  IFlipAll
//
//  Created by kishan on 28/11/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit

class TermsAndConditionsVC: UIViewController {
    
    @IBOutlet weak var lblTitleName: UILabel!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var socialView: UIView!

    
    var isFromAbout : String = ""
    var isFromTermsCondition : String = ""
    var isFromPrivacyPolicy : String = ""
    
    var titleText = ""
    
    var api: APIAction = .PrivacyPolicy

    override func viewDidLoad() {
        super.viewDidLoad()
      
        let helpCenterView = HelpCenterView.loadView()
        helpCenterView.frame = CGRect(x: 0, y: 0, width: socialView.bounds.width, height: socialView.bounds.height)
        socialView.addSubview(helpCenterView)

        self.lblTitleName.text? = titleText
        
        APIWebviewData()
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func APIWebviewData()
    {
     

        AlamofireModel.alamofireMethod(.post, apiAction: api, parameters: [:], Header: [:], handler:{res in

            if res.success == 1
            {
                
                if res.json.count > 0 {
                    
                    let headerString = "<head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></head>"
                    //webView.loadHTMLString(yourHTMLString, baseURL: nil)
                    self.webView.loadHTMLString(headerString +  res.json[0]["Description"].description, baseURL: nil)
                }

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
