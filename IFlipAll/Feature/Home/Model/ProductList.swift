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
        
        for (_,obj) in (data)
        {
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
    var Name = ""
    var Price = ""
    var Description = ""
    var Condition = ""
    var Images : [String] = [String]()
    
    
    func update(_ data : JSON)
    {
        print(Images)
        Id = strFromJSON(data["Id"])
        UserId = strFromJSON(data["UserId"])
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
