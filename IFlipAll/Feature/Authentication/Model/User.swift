//
//  User.swift
//  IFlipAll
//
//  Created by kishan on 25/12/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import Foundation
import SwiftyJSON

private var _sharedUser = User()
var kCurrentUser = _sharedUser.sharedInstance

//
//class User
//{
//    var user_id : String = ""
//    var name : String = ""
//    var client_id : String = ""
//
//    func update (_ data : JSON)
//    {
//
//
//        self.user_id = strFromJSON(data["user_id"])
//        self.name = strFromJSON(data["name"])
//        self.client_id = strFromJSON(data["client_id"])
//
//         self.saveToDefault()
//
//    }
//
//    let key = "userDeafultKey"
//
//       var sharedInstance: User
//       {
//           if self.user_id == ""
//           {
//               self.loadFromDefault()
//           }
//           return self
//       }
//
//        func loadFromDefault()
//        {
//
//            print("loadFromDefault ----------------------------------------------------------")
//
//            if let dict = UserDefaults.standard.value(forKey: self.key) as? [String : Any]
//            {
//
//                self.user_id = dict["user_id"] as? String ?? ""
//                self.name = dict["name"] as? String ?? ""
//                self.client_id = dict["client_id"] as? String ?? ""
//
//            }
//
//        }
//
//        func saveToDefault()
//        {
//
//            var dict : [String : Any] = [String : Any]()
//
//            dict["user_id"] = self.user_id
//            dict["name"] = self.name
//            dict["client_id"] = self.client_id
//
//            UserDefaults.standard.set(dict, forKey: key)
//            UserDefaults.standard.synchronize()
//
//        }
//
//        func logout()
//        {
//
//            self.user_id = ""
//            self.name = ""
//            self.client_id = ""
//
//            kCurrentUser.saveToDefault()
//
//        }
//
//
//}

class User
{
    var UserId : String = ""
    var FullName : String = ""
    var Email : String = ""
    var CountryCode : String = ""
    var PhoneNumber : String = ""
    var Verify : String = ""
    var ProfileImage : String = ""

    func update (_ data : JSON,saveToDefault: Bool = true)
    {

        self.UserId = strFromJSON(data["UserId"])
        self.FullName = strFromJSON(data["FullName"])
        self.Email = strFromJSON(data["Email"])
        self.CountryCode = strFromJSON(data["CountryCode"])
        self.PhoneNumber = strFromJSON(data["PhoneNumber"])
        self.Verify = strFromJSON(data["Verify"])
        self.ProfileImage = strFromJSON(data["ProfileImage"])

        if saveToDefault
        {
            self.saveToDefault()
        }
         

    }

    let key = "userDeafultKey"

       var sharedInstance: User
       {
           if self.UserId == ""
           {
               self.loadFromDefault()
           }
           return self
       }

        func loadFromDefault()
        {

            print("loadFromDefault ----------------------------------------------------------")

            if let dict = UserDefaults.standard.value(forKey: self.key) as? [String : Any]
            {

                self.UserId = dict["UserId"] as? String ?? ""
                self.FullName = dict["FullName"] as? String ?? ""
                self.Email = dict["Email"] as? String ?? ""
                self.CountryCode = dict["CountryCode"] as? String ?? ""
                self.PhoneNumber = dict["PhoneNumber"] as? String ?? ""
                self.Verify = dict["Verify"] as? String ?? ""
                self.ProfileImage = dict["ProfileImage"] as? String ?? ""

            }

        }

        func saveToDefault()
        {

            var dict : [String : Any] = [String : Any]()

            dict["UserId"] = self.UserId
            dict["FullName"] = self.FullName
            dict["Email"] = self.Email
            dict["CountryCode"] = self.CountryCode
            dict["PhoneNumber"] = self.PhoneNumber
            dict["Verify"] = self.Verify
            dict["ProfileImage"] = self.ProfileImage
           
            UserDefaults.standard.set(dict, forKey: key)
            UserDefaults.standard.synchronize()

        }

        func logout()
        {

            self.UserId = ""
            self.FullName = ""
            self.Email = ""
            self.CountryCode = ""
            self.PhoneNumber = ""
            self.Verify = ""
            self.ProfileImage = ""
           
            kCurrentUser.saveToDefault()

        }

}

//{"success":"1","message":"Login Success.","data":[{"UserId":"2","FullName":"Kishan
//kasundra","email":"kishankasundra10@gmail.com","countrycode":"+91","phonenumber":"9714270046","verify":"true","profileimage":"https:\/\/s3.us-east-2.amazonaws.com\/iflipbucket\/1609065028555.jpg"}]}
