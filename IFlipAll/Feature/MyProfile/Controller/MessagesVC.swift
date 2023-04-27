//
//  MessagesVC.swift
//  IFlipAll
//
//  Created by kishan on 28/11/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit
import Firebase

class MessagesVC: UIViewController {

    @IBOutlet weak var tblMessage: UITableView!
    
    let message = Message()
    var ref: DatabaseReference!
    var chatlistRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.setChatListObjerver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.chatlistRef != nil {
            self.chatlistRef.removeAllObservers()
        }
        
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
           self.navigationController?.popViewController(animated: true)
    }

}

extension MessagesVC : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.message.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : TblMessageListCell = tableView.dequeueReusableCell(withIdentifier: "TblMessageListCell", for: indexPath) as! TblMessageListCell
        
        
        let temp = self.message.list[indexPath.row]
        
        cell.lblUserName.text = temp.user_name
        cell.lblLastMessage.text = temp.last_chat_message
        
        let count = intFromStr(temp.total_message_count) - intFromStr(temp.read_message_count)
        cell.lblUnreadCount.isHidden = (count < 1)
        cell.lblUnreadCount.text = count.description
        
        cell.imgProfile.sd_setImage(with: URL(string:temp.user_image), placeholderImage:  UIImage(named: "ic_placeHolder"))
        cell.lblTime.text = Utilities.customeDateTimeFormatter(doubleFromStr(temp.last_chat_time),isChat: true)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let resultVC : ChatVC = Utilities.viewController(name: "ChatVC", storyboard: "MyProfile") as! ChatVC
        let temp = self.message.list[indexPath.row]
        resultVC.to_user_id = temp.user_id
        resultVC.to_user_name = temp.user_name
        resultVC.to_user_image = temp.user_image
        self.navigationController?.pushViewController(resultVC, animated: true)
    }
}


extension MessagesVC {
    
    func setChatListObjerver() {
        
        self.chatlistRef = ref.child("chatlist").child(kCurrentUser.UserId)
        self.chatlistRef.observe(.value, with: { (snapshot) in
            print("value:- \(snapshot)")
            if snapshot.value != nil {
                let json = JSON(snapshot.value!)
                self.message.list = []
                self.message.update(json)
                self.message.list.sort(by: {obj1,obj2 in
                    return doubleFromStr(obj1.last_chat_time) > doubleFromStr(obj2.last_chat_time)
                })
                
                //self.viewNoAtMessages.isHidden = (self.message.list.count != 0)
                self.tblMessage.reloadData()
            }
        })
    }
}
