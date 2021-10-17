//
//  ProductList.swift
//  IFlipAll
//
//  Created by kishan on 26/12/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import Foundation

var productlist = ProductList()

class ProductList
{
    
    var productdetail : [ProductDetail] = [ProductDetail]()
    
    
    func update(_ data:JSON)
    {
//        print("product details: - > ",data.first as? [String: Any])
        
        for (_,obj) in (data)
        {
//            guard let arrProductDetails = obj["ProductData"] as? [[String: Any]] else { return }
            
            let temp : ProductDetail = ProductDetail()
            temp.update(obj)
            self.productdetail.append(temp)
        }
        
    }
    
}

class ProductDetail
{
    var Id = ""
    var UserId = ""
    var UserName = ""
    var UserProfile = ""
    var Address = ""
    var Longitude = ""
    var Langitude = ""
    var CategoryName = ""
    var SubCategoryName = ""
    var Name = ""
    var Price = ""
    var Description = ""
    var Condition = ""
    var ProductType = ""
    var UserSince = ""
    var ProductSave = ""
    var ProductReport = ""
    var SoldStatus = ""
    var Negotiation = ""
    var Images : [String] = [String]()
    
    var manageSoldStatus: String? {
        return SoldStatus == "sold" ? "sold" : "Available"
    }
    
    var isButtonHide: Bool? {
        return SoldStatus == "sold" ? true : false
    }
    
    
    func update(_ data : JSON)
    {
        Id = strFromJSON(data["Id"])
        UserId = strFromJSON(data["UserId"])
        UserName = strFromJSON(data["UserName"])
        UserProfile = strFromJSON(data["UserProfile"])
        Address = strFromJSON(data["Address"])
        Longitude = strFromJSON(data["Longitude"])
        Langitude = strFromJSON(data["Langitude"])
        CategoryName = strFromJSON(data["CategoryName"])
        SubCategoryName = strFromJSON(data["SubCategoryName"])
        Name = strFromJSON(data["Name"])
        Price = strFromJSON(data["Price"])
        Description = strFromJSON(data["Description"])
        Condition = strFromJSON(data["Condition"])
        ProductType = strFromJSON(data["ProductType"])
        UserSince = strFromJSON(data["UserSince"])
        ProductSave = strFromJSON(data["ProductSave"])
        ProductReport = strFromJSON(data["ProductReport"])
        SoldStatus = strFromJSON(data["SoldStatus"])
        Negotiation = strFromJSON(data["Negotiation"])
        
        do {
            if let dataFromString = strFromJSON(data["Images"]).data(using: String.Encoding.utf8, allowLossyConversion: false) {
                let imagesJSONArray = try JSON(data: dataFromString)
                
                for (_, obj) in  imagesJSONArray {
                    self.Images.append(strFromJSON(obj["url"]))
                }
                
            }
        } catch{
            
        }
        
    }
}
