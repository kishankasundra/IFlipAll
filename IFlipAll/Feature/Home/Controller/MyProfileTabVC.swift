//
//  MyProfileTabVC.swift
//  IFlipAll
//
//  Created by kishan on 27/11/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit

class MyProfileTabVC: UIViewController {
    
        let options : [String] = ["Sell Products","Buy Products","Edit Profile","Change Password","Messages","About IFlipAll","Term of Services","Privacy Policy","Contact us","Safety Tips","FAQ","Settings","Logout"]
        
        let optionImgs : [String] = ["ic_sell_products","ic_buy_products","ic_edit_profile","ic_change_password","ic_messages","ic_about_iflipall","ic_term_of_services","ic_privacy_policy","ic_contact_us","ic_safety_tips","ic_faq","ic_setting","ic_logout"]

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension MyProfileTabVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : ProfileMenuTBLCell = tableView.dequeueReusableCell(withIdentifier: "ProfileMenuTBLCell", for: indexPath) as! ProfileMenuTBLCell
        
        cell.lblMenu.text = options[indexPath.row]
        cell.imgMenu.image = UIImage(named: optionImgs[indexPath.row]) ?? UIImage()
        
        if cell.lblMenu.text != "Messages"
        {
            cell.viewBgMessges.isHidden = true
        }
        else
        {
            cell.viewBgMessges.isHidden = false
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        switch indexPath.row {
        case 0:
            let resultVC : SellProductsVC = Utilities.viewController(name: "SellProductsVC", storyboard: "MyProfile") as! SellProductsVC
            self.navigationController?.pushViewController(resultVC, animated: true)
        case 1:
            let resultVC : BuyProductsVC = Utilities.viewController(name: "BuyProductsVC", storyboard: "MyProfile") as! BuyProductsVC
            self.navigationController?.pushViewController(resultVC, animated: true)
        case 2:
            let resultVC : EditProfileVC = Utilities.viewController(name: "EditProfileVC", storyboard: "MyProfile") as! EditProfileVC
            self.navigationController?.pushViewController(resultVC, animated: true)
        case 3:
            let resultVC : ChangePasswordVC = Utilities.viewController(name: "ChangePasswordVC", storyboard: "MyProfile") as! ChangePasswordVC
            self.navigationController?.pushViewController(resultVC, animated: true)
        case 4:
            let resultVC : MessagesVC = Utilities.viewController(name: "MessagesVC", storyboard: "MyProfile") as! MessagesVC
            self.navigationController?.pushViewController(resultVC, animated: true)
        case 5:
            let resultVC : AboutIFlipAllVC = Utilities.viewController(name: "AboutIFlipAllVC", storyboard: "MyProfile") as! AboutIFlipAllVC
            self.navigationController?.pushViewController(resultVC, animated: true)
        case 6:
            let resultVC : TermsAndConditionsVC = Utilities.viewController(name: "TermsAndConditionsVC", storyboard: "MyProfile") as! TermsAndConditionsVC
            resultVC.titleText = "Terms & Conditions"
            resultVC.link = "https://www.google.com"
            self.navigationController?.pushViewController(resultVC, animated: true)
        case 7:
            let resultVC : TermsAndConditionsVC = Utilities.viewController(name: "TermsAndConditionsVC", storyboard: "MyProfile") as! TermsAndConditionsVC
            resultVC.titleText = "Privacy Policy"
            resultVC.link = "https://www.google.com"
            self.navigationController?.pushViewController(resultVC, animated: true)
        case 8:
            let resultVC : ContactUsVC = Utilities.viewController(name: "ContactUsVC", storyboard: "MyProfile") as! ContactUsVC
            self.navigationController?.pushViewController(resultVC, animated: true)
        case 9:
            let resultVC : TermsAndConditionsVC = Utilities.viewController(name: "TermsAndConditionsVC", storyboard: "MyProfile") as! TermsAndConditionsVC
            resultVC.titleText = "Safety Tips"
            resultVC.link = "https://www.google.com"
            self.navigationController?.pushViewController(resultVC, animated: true)
        case 10:
            let resultVC : FAQVC = Utilities.viewController(name: "FAQVC", storyboard: "MyProfile") as! FAQVC
            self.navigationController?.pushViewController(resultVC, animated: true)
        case 11:
            let resultVC : FAQVC = Utilities.viewController(name: "FAQVC", storyboard: "MyProfile") as! FAQVC
            self.navigationController?.pushViewController(resultVC, animated: true)
        case 12:
            let alert = UIAlertController(title: "", message: "Are you sure you want to logout?".localized, preferredStyle: .alert)
                   alert.addAction(UIAlertAction(title: "Cancel".localized, style: .default) { action in
                   })
                   
                   alert.addAction(UIAlertAction(title: "Logout".localized, style: .destructive) { action in
                       
                       kCurrentUser.logout()
                       let resultVC : LoginVC = Utilities.viewController(name: "LoginVC", storyboard: "Authentication") as! LoginVC
                       self.navigationController?.pushViewController(resultVC, animated: true)
                    
                   })
                   
                   self.present(alert, animated: true, completion: nil)

        default:
            print("Error in selection")
        }
    }
    

}
