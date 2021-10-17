//
//  SafetyTips.swift
//  IFlipAll
//
//  Created by devangs.bhatt on 17/06/21.
//  Copyright © 2021 StarkTechnolabs. All rights reserved.
//

import Foundation

var safetyTip = SafetyTips()

class SafetyTips {
    var safetyTipDetails : [SafetyTipsData] = [SafetyTipsData]()
    
    func update(_ data:JSON) {
        for (_,obj) in (data) {
            let temp : SafetyTipsData = SafetyTipsData()
            temp.update(obj)
            self.safetyTipDetails.append(temp)
        }
    }

}


class SafetyTipsData {
    var Title: String?
    var Description: String?
    
    var isExpand: Bool = false
    
    func update(_ data : JSON) {
        Title = strFromJSON(data["Title"])
        Description = strFromJSON(data["Description"])
    }
}
