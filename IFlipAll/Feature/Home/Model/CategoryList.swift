//
//  CategoryList.swift
//  IFlipAll
//
//  Created by kishan on 25/12/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import Foundation

var categorylist = CategoryList()

class CategoryList
{
    
    var detail : [CategoryDetail] = [CategoryDetail]()
    
    var subCategorydetail : [SubCategoryDetail] = [SubCategoryDetail]()
    
    func update(_ data:JSON)
    {
        
        for (_,obj) in (data)
        {
            let temp : CategoryDetail = CategoryDetail()
            temp.update(obj)
            self.detail.append(temp)
        }
        
    }
    
    
    func updateSubCategory(_ data:JSON)
    {
        
        for (_,obj) in (data)
        {
            let temp : SubCategoryDetail = SubCategoryDetail()
            temp.updateSubCategory(obj)
            self.subCategorydetail.append(temp)
        }
        
    }
}

class CategoryDetail
{
    var CatId = ""
    var CategoryName = ""
    var Icon = ""
    
    func update(_ data : JSON)
    {
        CatId = strFromJSON(data["CatId"])
        CategoryName = strFromJSON(data["CategoryName"])
        Icon = strFromJSON(data["Icon"])
    
    }
}

class SubCategoryDetail
{
    var CategoryId = ""
    var SubCategoryName = ""
    var SubCategoryId = ""
    
    func updateSubCategory(_ data : JSON)
    {
        CategoryId = strFromJSON(data["CategoryId"])
        SubCategoryName = strFromJSON(data["SubCategoryName"])
        SubCategoryId = strFromJSON(data["SubCategoryId"])
    
    }
}
