//
//  AppDelegate.swift
//  Richvik
//
//  Created by kishan on 29/09/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit

func strFromJSON(_ data : JSON) -> String
{
    if data != JSON.null
    {
        return data.description
    }
    else
    {
        return ""
    }
}

func intFromJSON(_ data : JSON) -> Int
{
    if data != JSON.null
    {
        return intFromStr(data.description)
    }
    else
    {
        return 0
    }
}

func doubleFromJSON(_ data : JSON) -> Double
{
    if data != JSON.null
    {
        return doubleFromStr(data.description)
    }
    else
    {
        return 0
    }
}


func intFromStr(_ data : String) -> Int
{
    if let temp = Int(data)
    {
        return temp
    }
    else
    {
        return 0
    }
}

func doubleFromStr(_ data : String) -> Double
{
    if let temp = Double(data)
    {
        return temp
    }
    else
    {
        return 0
    }
}

func amountValue(_ str : String) -> String
{
   return "Rs." + str
}

extension String {
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
}

extension UIImage {
    func toString() -> String? {
        let data: Data? = self.pngData()
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
}

//extension UIImage {
//
//    convenience init?(withContentsOfUrl url: URL) throws {
//        let imageData = try Data(contentsOf: url)
//    
//        self.init(data: imageData)
//    }
//}
