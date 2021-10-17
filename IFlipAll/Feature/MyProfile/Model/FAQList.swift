//
//  FAQList.swift
//  IFlipAll
//
//  Created by devangs.bhatt on 17/06/21.
//  Copyright © 2021 StarkTechnolabs. All rights reserved.
//

import Foundation

var faqList = FAQList()

class FAQList {
    var faqDetails : [FAQData] = [FAQData]()
    
    func update(_ data:JSON) {
        for (_,obj) in (data) {
            let temp : FAQData = FAQData()
            temp.update(obj)
            self.faqDetails.append(temp)
        }
    }
}

class FAQData {
    var FaqId: String?
    var FaqQuestion: String?
    var FaqAnswer: String?
    var Icon: String?
    
    var isExpand: Bool = false
    
    func update(_ data : JSON) {
        FaqId = strFromJSON(data["FaqId"])
        FaqQuestion = strFromJSON(data["FaqQuestion"])
        FaqAnswer = strFromJSON(data["FaqAnswer"])
        Icon = strFromJSON(data["Icon"])
    }
}
