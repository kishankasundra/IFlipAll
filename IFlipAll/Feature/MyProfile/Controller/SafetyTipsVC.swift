//
//  SafetyTipsVC.swift
//  IFlipAll
//
//  Created by devangs.bhatt on 17/06/21.
//  Copyright © 2021 StarkTechnolabs. All rights reserved.
//

import UIKit

class SafetyTipsVC: UIViewController {

    @IBOutlet weak var tblSafetyTips: UITableView!
    @IBOutlet weak var socialView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tblSafetyTips.tableFooterView = UIView()
        
        let helpCenterView = HelpCenterView.loadView()
        helpCenterView.frame = CGRect(x: 0, y: 0, width: socialView.bounds.width, height: socialView.bounds.height)
        socialView.addSubview(helpCenterView)

        
        SafetyTipsAPICall()
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}

// MARK: - Custom Methods
extension SafetyTipsVC {
    // API Call
    // SafetyTipsVC api call
    private func SafetyTipsAPICall() {
        
        AlamofireModel.alamofireMethod(.get, apiAction: .SafetyTip, parameters: [:], Header: [:]) { res in
            if res.success == 1 {
                safetyTip = SafetyTips()
                safetyTip.update(res.json)
                
                DispatchQueue.main.async {
                    self.tblSafetyTips.dataSource = self
                    self.tblSafetyTips.delegate = self
                    self.tblSafetyTips.reloadData()
                }

            } else {
                AppInstance.showMessages(message: res.message)
            }
        } errorhandler: { error in
            AppInstance.showMessages(message: error.localizedDescription)
        }

    }
}

extension SafetyTipsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return safetyTip.safetyTipDetails.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : SafetyTipsCell = tableView.dequeueReusableCell(withIdentifier: "SafetyTipsCell", for: indexPath) as! SafetyTipsCell
        
        cell.lblSafetyTipQue.text = safetyTip.safetyTipDetails[indexPath.row].Title ?? ""
        cell.lblSafetyTipAns.text = safetyTip.safetyTipDetails[indexPath.row].isExpand == true ? safetyTip.safetyTipDetails[indexPath.row].Description ?? "" : ""

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? SafetyTipsCell else {
            return
        }
        safetyTip.safetyTipDetails[indexPath.row].isExpand.toggle()
        cell.lblSafetyTipAns.text = safetyTip.safetyTipDetails[indexPath.row].isExpand == true ? safetyTip.safetyTipDetails[indexPath.row].Description ?? "" : ""
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
