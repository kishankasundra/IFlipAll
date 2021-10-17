//
//  HelpCenterVC.swift
//  IFlipAll
//
//  Created by devangs.bhatt on 14/06/21.
//  Copyright © 2021 StarkTechnolabs. All rights reserved.
//

import UIKit

class HelpCenterVC: UIViewController {

    @IBOutlet weak var tblHelpCenter: UITableView!
    @IBOutlet weak var socialView: UIView!

    
    let options : [String] = ["About Us","Terms and Conditions","Privacy Policy","Contact Us","Safety Tips","FAQ"]

    let optionImgs : [String] = ["ic_about_us_new","ic_terms_condition","ic_privacy_policy_new","ic_contact_us_new","ic_safety_tips_new","ic_faq_new"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tblHelpCenter.tableFooterView = UIView()
        
        let helpCenterView = HelpCenterView.loadView()
        helpCenterView.frame = CGRect(x: 0, y: 0, width: socialView.bounds.width, height: socialView.bounds.height)
        socialView.addSubview(helpCenterView)

    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

// MARK:- UITableViewDataSource, UITableViewDelegate
extension HelpCenterVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let helpCenterCell = tableView.dequeueReusableCell(withIdentifier: "HelpCenterCell", for: indexPath)
        helpCenterCell.textLabel?.text = options[indexPath.row]
        helpCenterCell.imageView?.image = UIImage(named: optionImgs[indexPath.row])
        return helpCenterCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let resultVC : TermsAndConditionsVC = Utilities.viewController(name: "TermsAndConditionsVC", storyboard: "MyProfile") as! TermsAndConditionsVC
            resultVC.titleText = "About Us"
            resultVC.api = APIAction.About
            self.navigationController?.pushViewController(resultVC, animated: true)
            
        case 1:
            let resultVC : TermsAndConditionsVC = Utilities.viewController(name: "TermsAndConditionsVC", storyboard: "MyProfile") as! TermsAndConditionsVC
            resultVC.titleText = "Terms and Conditions"
            resultVC.api = APIAction.TermsCondition
            self.navigationController?.pushViewController(resultVC, animated: true)
            
        case 2:
            let resultVC : TermsAndConditionsVC = Utilities.viewController(name: "TermsAndConditionsVC", storyboard: "MyProfile") as! TermsAndConditionsVC
            resultVC.titleText = "Privacy Policy"
            resultVC.api = APIAction.PrivacyPolicy
            self.navigationController?.pushViewController(resultVC, animated: true)
            
        case 3:
            let resultVC : ContactUsVC = Utilities.viewController(name: "ContactUsVC", storyboard: "MyProfile") as! ContactUsVC
            self.navigationController?.pushViewController(resultVC, animated: true)
        
        case 4:
            let resultVC : SafetyTipsVC = Utilities.viewController(name: "SafetyTipsVC", storyboard: "MyProfile") as! SafetyTipsVC
            self.navigationController?.pushViewController(resultVC, animated: true)

        case 5:
            let resultVC : FAQVC = Utilities.viewController(name: "FAQVC", storyboard: "MyProfile") as! FAQVC
            self.navigationController?.pushViewController(resultVC, animated: true)
        default: return
        }
    }
}
