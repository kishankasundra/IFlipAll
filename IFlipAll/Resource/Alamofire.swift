//
//  AppDelegate.swift
//  Richvik
//
//  Created by kishan on 29/09/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import Foundation
@_exported import Alamofire
//import Firebase
//import Crashlytics
@_exported import SwiftyJSON

enum Environment: String {
    
    case Production = ""
    case Prod = "iji"
    case Dev = "http://3.141.21.255/IFLIPALL/index.php/Api/" //"http://54.152.99.160/IFILLPILL/index.php/Api/"
    
}

enum SocialLinks: String {
    case facebook = "https://www.facebook.com/IflipAll-105905531468489/"
    case pinterest = "https://in.pinterest.com/IflipAl/"
    case twitter = "https://twitter.com/iflipall/"
    case instagram = "https://www.instagram.com/iflipall/"
}

//API Environment set up
let apiEnvironment : Environment = .Dev
// Base Api URL
var baseURL: String = apiEnvironment.rawValue

var header: [String:String] = [:]
typealias reachability = (_ isReachable: Bool) -> Void

enum APIAction : String
{
    case SignIn = "SignIn"
    case SignUp = "SignUp"
    case SendOTP = "SendOTP"
    case VerifyEmail = "VerifyEmail"
    case ResetPassword = "ResetPassword"
    case ChangePassword = "ChangePassword"
    case CategoryList = "CategoryList"
    case AllProdcutList = "AllProdcutList"
    case Social = "Social"
    case ChangeProfile = "ChangeProfile"
    case MyProductList = "MyProductList"
    case AddProduct = "AddProduct"
    case EditProduct = "EditProduct"
    case ViewSelectedProduct = "ViewSelectedProduct"
    case DeleteProduct = "DeleteProduct"
    case FAQList = "FAQList"
    case About = "About"
    case PrivacyPolicy = "PrivacyPolicy"
    case TermsCondition = "TermsCondition"
    case ReportProduct = "ReportProduct"
    case SaveProduct = "SaveProduct"
    case ViewSaveProductList = "ViewSaveProductList"
    case Contact = "Contact"
    case SafetyTip = "SafetyTip"
    
}

class AlamofireResponse
{
    var success: Int = 1
    var code: Int = 200
    var json: JSON = JSON()
    var message: String = ""
    
    init(success: Int, code: Int, json: JSON,  message: String)
    {
        self.success = success
        self.code = code
        self.json = json
        self.message = message
    }
}

class AlamofireModel: NSObject
{
    
    typealias CompletionHandler = (_ response:AlamofireResponse) -> Void
    typealias ErrorHandler = (_ error : Error) -> Void
    
    class func alamofireMethod(_ method: Alamofire.HTTPMethod, apiAction: APIAction, parameters : [String : Any], Header: [String: String], tryAgainOnFail : Bool = false,  handler:@escaping CompletionHandler, errorhandler : @escaping ErrorHandler)
    {
        var header = Header
        header["Connection"] = "Close"
        header["X-platform"] = "iOS"
//        header["Content-Type"] = "application/json"
//        header["Authorization"] = "bearer es12QgSJYvEgFqqeyrFTKOZdBJEUxTCrPiJ1BEAxjFh5i4lU1k2_pqnvuD7QELifs3qlDECfOucLL3Zl46xn52mYmCdIpjgetjgkZiFXaAfu7deMTvQ56HxUxqRABS22iEw3fWk-T2h6cCxchU3SkcdViQj6a4fWnNR52ennRZLpCS_GR-ZE9X91b3lyEZU8X8qGYnBWi-zpuwgLyTmkg01FT5prNl3RywqH2hPtkamtWowCyCsfULAgHgdBrun382pgfr9BvXM2ExKb12ooQogtjCtWtjTuS5-7EIBQXAshxT1n2Hv08IjHWsXmFlwk"
        
//        if token.token != ""
//        {
//            header["Authorization"] = token.token
//        }
        
        let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "apple.com")
        
        reachabilityManager?.startListening()
        
        if let r = reachabilityManager
        {
            switch r.isReachable
            {
            case false:
                
                if tryAgainOnFail
                {
                    let alert = UIAlertController(title: "Alert", message: "No Network", preferredStyle: .alert)
                    
                    let action = UIAlertAction(title: "Retry", style: .default, handler: {_ in
                        
                        alamofireMethod(method, apiAction: apiAction, parameters: parameters, Header: header,tryAgainOnFail: tryAgainOnFail, handler: handler, errorhandler: errorhandler)
                        
                    })
                    
                    alert.addAction(action)
                    
                    AppInstance.window?.rootViewController?.present(alert, animated: true, completion: nil)
                    
                }
                else
                {
                    AppInstance.showMessages(message: "No Network")
                    errorhandler(NSError(domain: "No Network", code: 0, userInfo: nil))
                }
                
            case true:
                print("reachable")
                
                //Not reachable
                var alamofireManager : Alamofire.SessionManager?
                
                var UrlFinal = ""
                do
                {
                    try UrlFinal = baseURL + apiAction.rawValue.asURL().absoluteString
                }catch{}
                
                alamofireManager = Alamofire.SessionManager.default
                alamofireManager?.session.configuration.timeoutIntervalForRequest = 31
                alamofireManager?.session.configuration.timeoutIntervalForResource = 31
                
                print("Request Log ---------------------------------------------------------")
                print("URL:",UrlFinal)
                print("HEADER:",header)
                print("REQUEST:",parameters)
                print("---------------------------------------------------------End")
                
                AppInstance.showLoader()
                alamofireManager?.request(UrlFinal, method: method, parameters: parameters, encoding: URLEncoding.default, headers: header).responseJSON(queue: nil, options: JSONSerialization.ReadingOptions.allowFragments, completionHandler: { (response) in
                    
                    AppInstance.hideLoader()
                    
                    print("API Log Start---------------------------------------------------------")
                    print("URL:",UrlFinal)
                    print("HEADER:",header)
                    print("REQUEST:",parameters)
                    print("RESPONSE : ",response)
                    print("---------------------------------------------------------End")
                    
                    if response.response?.statusCode == 401
                    {
                        //kCurrentUser.logout()
                        //appDelegate.goToLoginScreenPage(transition: true)
                        AppInstance.showMessages(message: "Session Expired!!")
                    }
                    
                    if response.result.isSuccess
                    {
                        if let val = response.result.value
                        {
                            
                            var json : JSON = JSON(val)
                            
                            handler(AlamofireResponse(success: (intFromJSON(json["success"])), code: intFromJSON(json["code"]), json: json["data"], message: strFromJSON(json["message"])))
                            
                        }
                    }
                    else
                    {
                        if response.result.error != nil
                        {
                            let error = response.result.error!
                            
                            if tryAgainOnFail
                            {
                                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                                
                                let action = UIAlertAction(title: "Retry", style: .default, handler: {_ in
                                    
                                    alamofireMethod(method, apiAction: apiAction, parameters: parameters, Header: header,tryAgainOnFail : tryAgainOnFail, handler: handler, errorhandler: errorhandler)
                                    
                                })
                                
                                alert.addAction(action)
                                
                                AppInstance.window?.rootViewController?.present(alert, animated: true, completion: nil)
                                
                            }
                            else
                            {
                                errorhandler(error)
                            }
                            
                        }
                    }
                })
            }
        }
    }
    
    class func alamofireMethodWithImages(_ method: Alamofire.HTTPMethod, apiAction: APIAction, parameters : [String : Any], Header: [String: String], images : [String : UIImage], handler:@escaping CompletionHandler, errorhandler : @escaping ErrorHandler)
    {
        
        var header = Header
        header["Connection"] = "Close"
        header["X-platform"] = "iOS"
//        header["Content-Type"] = "application/json"
//        header["Authorization"] = "bearer RBmXuFZQ_ZnMNO2F9Acuvdjjp0zl4MR7vmCTF6AtHaCsZGeGTULAM5mTKTKcsJnqDxSeLKO6nEWALuyGYFfGA-7t1TLfbmxwRwVfHPiGYuSHwXxoqwAEml0Zfeam83FxrUQdcDNEcHUnkcVMWjgZiXCQVYns_LJJ3yxQEB7_h1tLstMC04q9q8lfjNWvwZMfSu28fuXV08BLJGetLNL19dG6xGaKrWkF_rpz1TgeUGYOSjGpB8nnSpMPy7NTGYXqqOXCaFI1J2LUUngZ8KE-uAlfYDB8mveHK4YRSGkYsUB1P8ODC85WE80N3RoADb0y"
        
        let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "apple.com")
        
        reachabilityManager?.startListening()
        
        if let r = reachabilityManager
        {
            switch r.isReachable
            {
            case false:
                
                errorhandler(NSError(domain: "No Network", code: 0, userInfo: nil))
                
            case true:
                print("reachable")
                
                //Not reachable
                var alamofireManager : Alamofire.SessionManager?
                
                var UrlFinal = ""
                do
                {
                    try UrlFinal = baseURL + apiAction.rawValue.asURL().absoluteString
                }catch{}
                
                alamofireManager = Alamofire.SessionManager.default
                alamofireManager?.session.configuration.timeoutIntervalForRequest = 31
                alamofireManager?.session.configuration.timeoutIntervalForResource = 31
                
                var _parameters = parameters
                
                print(UrlFinal)
                print(header)
                print(parameters)
                print(images)
                
                AppInstance.showLoader()
                
                alamofireManager?.upload(multipartFormData: { (multipartFormData) in
                    
                    
                    for (key,value) in _parameters
                    {
                        
                        //(value as! String).data(using: String.Encoding.utf8)!
                        multipartFormData.append("\(value)".data(using: .utf8)! , withName: key)
                    }
                    
                    for (key,value) in images
                    {
                        
                        if let data = value.jpegData(compressionQuality: 1)//UIImageJPEGRepresentation(value,1)
                        {
                            //multipartFormData.append(data, withName: key, mimeType: "image/jpeg")
                            multipartFormData.append(data, withName: key, fileName: key + ".png", mimeType: "image/png")
                        }
                    }
                    
                }, to: UrlFinal, method : method, headers : header, encodingCompletion: { (encodingResult) in
                    
                    AppInstance.hideLoader()
                    
                    switch encodingResult {
                    case .success(let upload, _, _):
                        
                        upload.responseJSON(completionHandler: { (response) in
                            
                            print(response)
                            if response.response?.statusCode == 401
                            {
                                // kCurrentUser.logout()
                                // appDelegate.goToLoginScreenPage(transition: true)
                                AppInstance.showMessages(message: "Session Expired!!")
                            }
                            
                            if response.result.isSuccess
                            {
                                if let val = response.result.value
                                {
                                    var json : JSON = JSON(val)
                                    
                                    handler(AlamofireResponse(success: (intFromJSON(json["success"])), code: intFromJSON(json["code"]), json: json["data"], message: strFromJSON(json["message"])))
                                }
                            }
                            else
                            {
                                if response.result.error != nil
                                {
                                    errorhandler(response.result.error! as NSError)
                                }
                            }
                            
                            
                        })
                        
                    case .failure(let encodingError):
                        
                        errorhandler(encodingError )
                    }
                    
                })
                
                
            }
        }
    }
    
    class func reachabilityCheck( maxRetries: Int = 3, isRecheable: @escaping reachability)
    {
        let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "apple.com")
        
        reachabilityManager?.startListening()
        
        if let r = reachabilityManager
        {
            switch r.isReachable
            {
            case false:
                print("unreachable, retry no. -> " + (abs(maxRetries - 3)).description)
                if maxRetries == 0
                {
                    isRecheable(false)
                }
                else
                {
                    usleep(10000) // = 0.01 seconds
                    reachabilityCheck(maxRetries: (maxRetries-1), isRecheable: isRecheable)
                }
            case true:
                
                isRecheable(true)
            }
        }
    }
}



