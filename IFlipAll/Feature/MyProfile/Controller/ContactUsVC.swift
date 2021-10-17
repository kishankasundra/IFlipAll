//
//  ContactUsVC.swift
//  IFlipAll
//
//  Created by kishan on 28/11/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit

class ContactUsVC: UIViewController {

    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtViewMessage: UITextView!
    
    @IBOutlet weak var btnSubmit: UIButton!
    
    @IBOutlet weak var socialView: UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        let helpCenterView = HelpCenterView.loadView()
        helpCenterView.frame = CGRect(x: 0, y: 0, width: socialView.bounds.width, height: socialView.bounds.height)
        socialView.addSubview(helpCenterView)

    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnSubmitAction(_ sender: UIButton) {
        if isValid() {
            contactUsAPICall()
        }
    }
}


extension ContactUsVC {
    
    private func configureUI() {
        
        txtName.text = kCurrentUser.FullName
        txtEmail.text = kCurrentUser.Email
        
        let nameAttributedPlaceholder = NSAttributedString(string: "Name",
                                                    attributes: [NSAttributedString.Key.foregroundColor: appColors.purpleColor])
        
        let emailAttributedPlaceholder = NSAttributedString(string: "Email",
                                                     attributes: [NSAttributedString.Key.foregroundColor: appColors.purpleColor])
        
        txtName.attributedPlaceholder = nameAttributedPlaceholder
        
        txtEmail.attributedPlaceholder = emailAttributedPlaceholder
    }
    
    private func isValid() -> Bool {
        if txtName.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            AppInstance.showMessages(message: appString.empty_name_msg)
            return false
        }
        
        if txtEmail.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            AppInstance.showMessages(message: appString.empty_email_msg)
            return false
        }
        
        if !Utilities.isValidEmail(txtEmail.text?.trimmingCharacters(in: .whitespaces) ?? "") {
            AppInstance.showMessages(message: appString.invalid_email_msg)
        }
        
        if txtViewMessage.text.trimmingCharacters(in: .whitespaces).count == 0 || txtViewMessage.text.trimmingCharacters(in: .whitespaces) == "Write Here" {
            AppInstance.showMessages(message: appString.empty_message_msg)
            return false
        }
        
        return true
    }
    
    // API Call
    // Contact US api call
    private func contactUsAPICall() {
        let contactParams: [String: Any] = ["Name": txtName.text?.trimmingCharacters(in: .whitespaces) ?? "",
                                            "Email": txtEmail.text?.trimmingCharacters(in: .whitespaces) ?? "",
                                            "Msg": txtViewMessage.text.trimmingCharacters(in: .whitespaces)]
        
        AlamofireModel.alamofireMethod(.post, apiAction: .Contact, parameters: contactParams, Header: [:]) { res in
            if res.success == 1 {
                print("Before",kCurrentUser.FullName, kCurrentUser.Email)
                kCurrentUser.FullName = self.txtName.text!
                kCurrentUser.Email = self.txtEmail.text!
                kCurrentUser.saveToDefault()
                print("After",kCurrentUser.FullName, kCurrentUser.Email)
                self.navigationController?.popViewController(animated: true)
            } else {
                AppInstance.showMessages(message: res.message)
            }
        } errorhandler: { error in
            AppInstance.showMessages(message: error.localizedDescription)
        }

    }
    
}

extension ContactUsVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        txtViewMessage.text = txtViewMessage.text.trimmingCharacters(in: .whitespaces) == "Write Here" ? "" : txtViewMessage.text.trimmingCharacters(in: .whitespaces)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        txtViewMessage.text = txtViewMessage.text.trimmingCharacters(in: .whitespaces).count == 0 ? "Write Here" : txtViewMessage.text.trimmingCharacters(in: .whitespaces)
    }
}
