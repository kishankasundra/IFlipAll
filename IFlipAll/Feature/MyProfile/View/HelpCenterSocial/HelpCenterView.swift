//
//  HelpCenterView.swift
//  IFlipAll
//
//  Created by devangs.bhatt on 15/06/21.
//  Copyright © 2021 StarkTechnolabs. All rights reserved.
//

import UIKit

class HelpCenterView: UIView {
    
    @IBOutlet weak var btnFB: UIButton!
    @IBOutlet weak var btnTwiter: UIButton!
    @IBOutlet weak var btnPinterest: UIButton!
    @IBOutlet weak var btnInsta: UIButton!
    @IBOutlet weak var btnPrivacyPolicy: UIButton!
    @IBOutlet weak var btnTermsCondition: UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
   
    static func loadView() -> HelpCenterView {
        return Bundle.main.loadNibNamed("HelpCenterView", owner: nil, options: nil)?[0] as! HelpCenterView
    }
    
    
    @IBAction func btnFBAction(_ sender: UIButton) {
        Utilities.openURL(SocialLinks.facebook.rawValue)
    }
    
    @IBAction func btnTwiterAction(_ sender: UIButton) {
        Utilities.openURL(SocialLinks.twitter.rawValue)
    }
    
    @IBAction func btnPinterestAction(_ sender: UIButton) {
        Utilities.openURL(SocialLinks.pinterest.rawValue)
    }
    
    @IBAction func btnInstaAction(_ sender: UIButton) {
        Utilities.openURL(SocialLinks.instagram.rawValue)
    }
    
    @IBAction func btnPrivacyPolicyAction(_ sender: UIButton) {
        let resultVC : TermsAndConditionsVC = Utilities.viewController(name: "TermsAndConditionsVC", storyboard: "MyProfile") as! TermsAndConditionsVC
        resultVC.titleText = "Privacy Policy"
        resultVC.api = APIAction.PrivacyPolicy
        UIApplication.topViewController()?.navigationController?.pushViewController(resultVC, animated: true)
    }
    
    @IBAction func btnTermsConditionAction(_ sender: UIButton) {
        let resultVC : TermsAndConditionsVC = Utilities.viewController(name: "TermsAndConditionsVC", storyboard: "MyProfile") as! TermsAndConditionsVC
        resultVC.titleText = "Terms and Conditions"
        resultVC.api = APIAction.TermsCondition
        UIApplication.topViewController()?.navigationController?.pushViewController(resultVC, animated: true)
    }

}
