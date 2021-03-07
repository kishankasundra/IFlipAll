//
//  Message.swift
//  Fighter Connect
//
//  Created by Kishan Kasundra on 19/07/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import Foundation
import SwiftyJSON



class Message {
    var list : [MessageData] = [MessageData]()
    
    func update (_ data : JSON)
    {
        for (_,obj) in data
        {
            if obj != JSON.null {
                let temp : MessageData = MessageData()
                temp.update(obj)
                self.list.append(temp)
            }
        }
    }
}

class MessageData {
    
    var user_id = ""
    var user_name = ""
    var user_image = ""
    var last_chat_message = ""
    var last_chat_time = ""
    var last_chat_from_user_id = ""
    var total_message_count = ""
    var read_message_count = ""
    
    func update(_ data: JSON) {
        
         user_id = strFromJSON(data["user_id"])
         user_name = strFromJSON(data["user_name"])
         user_image = strFromJSON(data["user_image"])
         last_chat_message = strFromJSON(data["last_chat_message"])
         last_chat_time = strFromJSON(data["last_chat_time"])
         last_chat_from_user_id = strFromJSON(data["last_chat_from_user_id"])
         total_message_count = strFromJSON(data["total_message_count"])
         read_message_count = strFromJSON(data["read_message_count"])
    }
    
}

class Chat {
    var list : [ChatData] = [ChatData]()
    
    
    func update (_ data : JSON)
    {
        for (_,obj) in data
        {
            if obj != JSON.null {
                let temp : ChatData = ChatData()
                temp.update(obj)
                self.list.append(temp)
            }
        }
    }
}


class ChatData {
    
    var from_user_id : String = ""
    var message: String = ""
    var time: String = ""
    
    
    func update(_ data: JSON) {
        
         from_user_id = strFromJSON(data["from_user_id"])
         message = strFromJSON(data["message"])
         time = strFromJSON(data["time"])
        
    }
}
