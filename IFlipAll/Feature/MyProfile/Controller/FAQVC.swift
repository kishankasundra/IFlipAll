//
//  FAQVC.swift
//  IFlipAll
//
//  Created by kishan on 28/11/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit

class FAQVC: UIViewController {

    @IBOutlet weak var tblFAQList: UITableView!
    @IBOutlet weak var socialView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblFAQList.tableFooterView = UIView()
        
        let helpCenterView = HelpCenterView.loadView()
        helpCenterView.frame = CGRect(x: 0, y: 0, width: socialView.bounds.width, height: socialView.bounds.height)
        socialView.addSubview(helpCenterView)

        FAQListAPICall()
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}

// MARK: - Custom Methods
extension FAQVC {
    // API Call
    // FAQ List api call
    private func FAQListAPICall() {
        
        AlamofireModel.alamofireMethod(.get, apiAction: .FAQList, parameters: [:], Header: [:]) { res in
            if res.success == 1 {
                faqList = FAQList()
                faqList.update(res.json)
                
                DispatchQueue.main.async {
                    self.tblFAQList.dataSource = self
                    self.tblFAQList.delegate = self
                    self.tblFAQList.reloadData()
                }

            } else {
                AppInstance.showMessages(message: res.message)
            }
        } errorhandler: { error in
            AppInstance.showMessages(message: error.localizedDescription)
        }

    }
}

extension FAQVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faqList.faqDetails.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : FaqTBLCell = tableView.dequeueReusableCell(withIdentifier: "FaqTBLCell", for: indexPath) as! FaqTBLCell
        
        cell.lblFaqList.text = faqList.faqDetails[indexPath.row].FaqQuestion ?? ""
        cell.lblFaqAnswer.text = faqList.faqDetails[indexPath.row].isExpand == true ? faqList.faqDetails[indexPath.row].FaqAnswer ?? "" : ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? FaqTBLCell else {
            return
        }
        faqList.faqDetails[indexPath.row].isExpand.toggle()
        cell.lblFaqAnswer.text = faqList.faqDetails[indexPath.row].isExpand == true ? faqList.faqDetails[indexPath.row].FaqAnswer ?? "" : ""
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

