//
//  LoginVC.swift
//  IFlipAll
//
//  Created by kishan on 28/11/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKLoginKit
import GoogleSignIn

var isFromSocial : Bool = false

class LoginVC: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var imgAcceptTermsAndService: UIImageView!
    
    var FullName = ""
    var SocialId = ""
    var SocialType = ""
    var DeviceId = ""
    var DeviceType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imgAcceptTermsAndService.isHidden = true
        
    }
    
    @IBAction func btnAcceptTermsAndServiceAction(_ sender: UIButton) {
        
        if self.imgAcceptTermsAndService.isHidden == true
        {
            self.imgAcceptTermsAndService.isHidden = false
        }
        else
        {
            self.imgAcceptTermsAndService.isHidden = true
        }
    }
    
    @IBAction func btnSignInAction(_ sender: UIButton) {
        
        if validation()
        {
            self.APISignIn()
        }
        
    }
    
    @IBAction func btnForgotPasswordAction(_ sender: UIButton) {
        let resultVC : ForgotPasswordVC = Utilities.viewController(name: "ForgotPasswordVC", storyboard: "Authentication") as! ForgotPasswordVC
        self.navigationController?.pushViewController(resultVC, animated: true)
    }
    
    @IBAction func btnCreateAnAccountAction(_ sender: UIButton) {
        let resultVC : RegisterVC = Utilities.viewController(name: "RegisterVC", storyboard: "Authentication") as! RegisterVC
        self.navigationController?.pushViewController(resultVC, animated: true)
    }
    
    func validation() -> Bool
    {
        self.txtEmail.text = Utilities.trim(self.txtEmail.text!)
        self.txtPassword.text = Utilities.trim(self.txtPassword.text!)
        
        if self.txtEmail.text == ""
        {
            AppInstance.showMessages(message: appString.empty_email_msg)
        }
        else if !Utilities.isValidEmail(self.txtEmail.text!)
        {
            AppInstance.showMessages(message: appString.invalid_email_msg)
        }
        else if self.txtPassword.text == ""
        {
            AppInstance.showMessages(message: appString.empty_password_msg)
        }
        else if self.imgAcceptTermsAndService.isHidden == true
        {
            AppInstance.showMessages(message: appString.unselect_terms_msg)
        }
        else
        {
            return true
        }
        
        return false
        
    }
    
    @IBAction func btnLoginWithFB(_ sender: UIButton) {
        
        self.LogInWithFacebook()
        
    }
    
    @IBAction func btnLoginWithGoogle(_ sender: UIButton) {
        
        self.GoogleSignIn()
        
    }
    
}

extension LoginVC
{
    func APISignIn()
    {
     
        let param : [String:Any] = ["Email":self.txtEmail.text!,
                                    "Password":self.txtPassword.text!]

        AlamofireModel.alamofireMethod(.post, apiAction: .SignIn, parameters: param, Header: [:], handler:{res in

            if res.success == 1
            {
                kCurrentUser.update(res.json[0])
                
                if kCurrentUser.Verify == "True"
                {
                    let resultVC : HomeVC = Utilities.viewController(name: "HomeVC", storyboard: "Home") as! HomeVC
                    self.navigationController?.pushViewController(resultVC, animated: true)
                }
                else
                {
                    self.verifyEmailPopup()
                    print(kCurrentUser.Verify)
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
    
    func APISendOTP()
    {
     
        let param : [String:Any] = ["Email":self.txtEmail.text!]

        AlamofireModel.alamofireMethod(.post, apiAction: .SendOTP, parameters: param, Header: [:], handler:{res in

            if res.success == 1
            {
                
                otpdata = OTPData()
                otpdata.update(res.json)
                
                let resultVC : OTPVC = Utilities.viewController(name: "OTPVC", storyboard: "Authentication") as! OTPVC
                resultVC.email = self.txtEmail.text!
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
    
    func APISocial()
    {
     
        let param : [String:Any] = ["FullName":FullName,
                                    "SocialId":SocialId,
                                    "SocialType":self.SocialType,
                                    "DeviceId":"1234",
                                    "DeviceType":"I"]

        AlamofireModel.alamofireMethod(.post, apiAction: .Social, parameters: param, Header: [:], handler:{res in

            if res.success == 1
            {
                kCurrentUser.update(res.json[0],saveToDefault: false)
                
                if kCurrentUser.PhoneNumber == "" || kCurrentUser.PhoneNumber == "0"
                {
                    //editprofile
                    //isFrofsocial
                    isFromSocial = true
                    let resultVC : EditProfileVC = Utilities.viewController(name: "EditProfileVC", storyboard: "MyProfile") as! EditProfileVC
                    self.navigationController?.pushViewController(resultVC, animated: true)
                }
                else
                {
                    kCurrentUser.saveToDefault()
                    let resultVC : HomeVC = Utilities.viewController(name: "HomeVC", storyboard: "Home") as! HomeVC
                    self.navigationController?.pushViewController(resultVC, animated: true)
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

extension LoginVC
{
    func verifyEmailPopup()
       {
//           let alert = UIAlertController(title: "", message: "Please first verify your email", preferredStyle: .alert)
//
//           let action = UIAlertAction(title: "Ok", style: .default, handler: {_ in
//
//            self.APISendOTP()
//
//           })
//
//           alert.addAction(action)
//
//           self.present(alert, animated: true, completion: nil)
        
           let alert = UIAlertController(title: "", message: "Please first verify your email".localized, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "Cancel".localized, style: .default) { action in
           })
           
           alert.addAction(UIAlertAction(title: "Ok".localized, style: .destructive) { action in
               
               self.APISendOTP()
           })
           
           self.present(alert, animated: true, completion: nil)
       }
    
}

extension LoginVC
{
    func LogInWithFacebook()
    {
        let loginManager = LoginManager()
        
        loginManager.loginBehavior = .browser
        
        loginManager.logIn(permissions: ["public_profile","email"], from: self, handler: {(loginResult,error) in
            
            if error == nil
            {
                if loginResult!.isCancelled == true
                {
                  return
                }
                
                let params = ["fields" : "id, name, first_name, last_name, picture.type(large), email "]
                let graphRequest = GraphRequest.init(graphPath: "/me", parameters: params)
                let Connection = GraphRequestConnection()
                Connection.add(graphRequest) { (Connection, result, error) in
                    let info = result as! [String : AnyObject]
                    print(info)
                    
                    let fbData = FBData()
                    fbData.update(info: info)
                    print(fbData.email,fbData.first_name)
                    
                    self.FullName = fbData.first_name + fbData.last_name
                    self.SocialId = fbData.id
                    self.SocialType = "F"
                    self.DeviceId = "1234"
                    self.DeviceType = "I"
                    
                    self.APISocial()

                                    
                }
                Connection.start()
                
            }
        })
    }
    
    class FBData
    {
        var id : String = ""
        var email : String = ""
        var first_name : String = ""
        var last_name : String = ""
        
        func update(info : [String : AnyObject])
        {
            self.id = info["id"] as? String ?? ""
            self.email = info["email"] as? String ?? ""
            self.first_name = info["first_name"] as? String ?? ""
            self.last_name = info["last_name"] as? String ?? ""
        }
        
    }

    
}

extension LoginVC : GIDSignInDelegate{
    
    func GoogleSignIn()
    {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance().signIn()

    }
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        
    }
    
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
                     withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            
            if user.userID != nil{
                self.SocialId = user.userID
                print(self.SocialId)
            }

//            if user.profile.hasImage{
//                self.googleImage = user.profile.imageURL(withDimension: 100)
//                print(self.googleImage)
//            }

            if user.profile.name != nil{
                self.FullName = user.profile.name
                print(self.FullName)
            }

//            if user.profile.email != nil{
//                self.email = user.profile.email
//                print(self.email)
//            }
            
            self.APISocial()
            
        } else {
            print("\(String(describing: error))")
        }
    }
}


