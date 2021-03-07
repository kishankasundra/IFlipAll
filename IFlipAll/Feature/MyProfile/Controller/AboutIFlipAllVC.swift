//
//  AboutIFlipAllVC.swift
//  IFlipAll
//
//  Created by kishan on 28/11/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit
import WebKit

class AboutIFlipAllVC: UIViewController, WKUIDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    
    var isFromAbout : String = ""
    var isFromTermsCondition : String = ""
    var isFromPrivacyPolicy : String = ""
    
    var titleText = ""
    var link = "https://www.google.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.lblTitleName.text? = titleText

        if let url = URL(string: self.link)
        {
            let urlRequest = URLRequest(url: url)
            self.webView.loadRequest(urlRequest)
            
            self.webView.allowsInlineMediaPlayback = true;
            self.webView.mediaPlaybackRequiresUserAction = false;
        }
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
           self.navigationController?.popViewController(animated: true)
       }
    
}
