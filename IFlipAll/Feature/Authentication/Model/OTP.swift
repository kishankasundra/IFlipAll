//
//  OTP.swift
//  IFlipAll
//
//  Created by kishan on 25/12/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import Foundation

var otpdata = OTPData()

class OTPData
{
    
    var otpdetail : [OTPDetail] = [OTPDetail]()
    
    func update(_ data:JSON)
    {
        
        for (_,obj) in (data)
        {
            let temp : OTPDetail = OTPDetail()
            temp.update(obj)
            self.otpdetail.append(temp)
        }
        
    }
    
}

class OTPDetail
{
    var UserId = ""
    var OTP = ""
    
    func update(_ data : JSON)
    {
        UserId = strFromJSON(data["UserId"])
        OTP = strFromJSON(data["OTP"])
    
    }
}
