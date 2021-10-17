//
//  MyProductList.swift
//  IFlipAll
//
//  Created by kishan on 02/01/21.
//  Copyright © 2021 StarkTechnolabs. All rights reserved.
//

import Foundation

var myProductList = MyProductList()

class MyProductList
{
    
    var myProductDetail : [MyProductDetail] = [MyProductDetail]()
    
    
    func update(_ data:JSON)
    {
        
        for (_,obj) in (data)
        {
            let temp : MyProductDetail = MyProductDetail()
            temp.update(obj)
            self.myProductDetail.append(temp)
        }
        
    }
    
}

class MyProductDetail
{
    var Id = ""
    var UserName = ""
    var UserProfile = ""
    var Address = ""
    var Longitude = ""
    var Langitude = ""
    var CategoryName = ""
    var Name = ""
    var Price = ""
    var Description = ""
    var Condition = ""
    var ProductType = ""
    var UserSince = ""
    var ProductSave = ""
    var ProductReport = ""
    var SoldStatus = ""
    var Images : [String] = [String]()
    
    
    var manageSoldStatus: String? {
        return SoldStatus == "sold" ? "sold" : "Available"
    }
    
    var isButtonHide: Bool? {
        return SoldStatus == "sold" ? true : false
    }
    
    func update(_ data : JSON)
    {
        print(Images)
        Id = strFromJSON(data["Id"])
        UserName = strFromJSON(data["UserName"])
        UserProfile = strFromJSON(data["UserProfile"])
        Address = strFromJSON(data["Address"])
        Longitude = strFromJSON(data["Longitude"])
        Langitude = strFromJSON(data["Langitude"])
        CategoryName = strFromJSON(data["CategoryName"])
        Name = strFromJSON(data["Name"])
        Price = strFromJSON(data["Price"])
        Description = strFromJSON(data["Description"])
        Condition = strFromJSON(data["Condition"])
        ProductType = strFromJSON(data["ProductType"])
        UserSince = strFromJSON(data["UserSince"])
        ProductSave = strFromJSON(data["ProductSave"])
        ProductReport = strFromJSON(data["ProductReport"])
        SoldStatus = strFromJSON(data["SoldStatus"])
        
        do {
            if let dataFromString = strFromJSON(data["Images"]).data(using: String.Encoding.utf8, allowLossyConversion: false) {
                let imagesJSONArray = try JSON(data: dataFromString)
                
                for (_, obj) in  imagesJSONArray {
                    self.Images.append(strFromJSON(obj["url"]))
                    print(obj)
                }
                
            }
        } catch{
            
        }
        
    }
}

