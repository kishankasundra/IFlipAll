//
//  FAQVC.swift
//  IFlipAll
//
//  Created by kishan on 28/11/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit

class FAQVC: UIViewController {
    
    let options : [String] = ["Posting Ad","Manage Ads","How to leave feedback or report illegal activity?","Notification","Premium Services","How to buy on IFlipAll?"]
    
    let optionImgs : [String] = ["ic_posting_ad","ic_manage_ads","ic_leave_feedback","ic_notification-1","ic_premium_services","ic_how_to_buy"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
           self.navigationController?.popViewController(animated: true)
       }

}

extension FAQVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : FaqTBLCell = tableView.dequeueReusableCell(withIdentifier: "FaqTBLCell", for: indexPath) as! FaqTBLCell
        
        cell.lblFaqList.text = self.options[indexPath.row]
        cell.imgFaqList.image = UIImage(named: self.optionImgs[indexPath.row]) ?? UIImage()
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        //let id =  self.options[indexPath.row]
        
        switch indexPath.row {
        case 0:
            let resultVC : NotificationVC = Utilities.viewController(name: "NotificationVC", storyboard: "MyProfile") as! NotificationVC
            self.navigationController?.pushViewController(resultVC, animated: true)
        case 1:
            let resultVC : NotificationVC = Utilities.viewController(name: "NotificationVC", storyboard: "MyProfile") as! NotificationVC
            self.navigationController?.pushViewController(resultVC, animated: true)
        case 2:
            let resultVC : NotificationVC = Utilities.viewController(name: "NotificationVC", storyboard: "MyProfile") as! NotificationVC
            self.navigationController?.pushViewController(resultVC, animated: true)
        case 3:
            let resultVC : NotificationVC = Utilities.viewController(name: "NotificationVC", storyboard: "MyProfile") as! NotificationVC
            self.navigationController?.pushViewController(resultVC, animated: true)
        case 4:
            let resultVC : NotificationVC = Utilities.viewController(name: "NotificationVC", storyboard: "MyProfile") as! NotificationVC
            self.navigationController?.pushViewController(resultVC, animated: true)
        case 5:
            let resultVC : NotificationVC = Utilities.viewController(name: "NotificationVC", storyboard: "MyProfile") as! NotificationVC
            self.navigationController?.pushViewController(resultVC, animated: true)
        default:
            print("Error in selection")
        }
    }
    

}

