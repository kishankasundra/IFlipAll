//
//  ChatVC.swift
//  IFlipAll
//
//  Created by kishan on 29/11/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit
import Firebase

var activeChatUserId = ""
class ChatVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var clnSuggestions: UICollectionView!
    @IBOutlet weak var cnstTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var txtMessage: UITextView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!

    
    var to_user_id = ""
    var to_user_name = ""
    var to_user_image = ""
    var to_user_firebase_token = ""
    var isFromMemberList: Bool = false
    var total_message_count = ""

    var chat = Chat()
    let placeHolderText = "Type here.."
    
    var ref: DatabaseReference!
    var chatRef: DatabaseReference!
    var tokenRef: DatabaseReference!
    
    var arrSuggestedMessage: [String] = ["Hi, is this item available?", "Where are you located?", "Is the price negotiation?"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if to_user_id == "" {
            to_user_id = "0"
        }
        self.txtMessage.textColor = appColors.placeHolderText1
        self.txtMessage.text = placeHolderText
        ref = Database.database().reference()
        self.tableView.estimatedRowHeight = 120
        self.tableView.rowHeight = UITableView.automaticDimension
        self.lblName.text = self.to_user_name
        activeChatUserId = self.to_user_id
        self.imgUser.sd_setImage(with: URL(string:self.to_user_image), placeholderImage:  UIImage(named: "ic_imgfighters"))
        // Do any additional setup after loading the view.
        self.tableView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        //self.tableView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.setChatListObjerver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.chatRef != nil {
            self.chatRef.removeAllObservers()
            self.tokenRef.removeAllObservers()
        }
        activeChatUserId = ""
        
    }
    
    @IBAction func btnBackAction(_ sender: UIButton)
    {
        let count = self.navigationController?.viewControllers.count ?? 0
        
        print(count)
        if (self.isFromMemberList && count > 2) {
            self.navigationController?.popToViewController(self.navigationController!.viewControllers[count - 3] , animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
        
    }

    @IBAction func btnSafetyTipsAction(_ sender: UIButton) {
        let resultVC : SafetyTipsVC = Utilities.viewController(name: "SafetyTipsVC", storyboard: "MyProfile") as! SafetyTipsVC
        self.navigationController?.pushViewController(resultVC, animated: true)
    }
    
    @IBAction func btnSebndAction(_ sender: UIButton) {
        
        self.txtMessage.text = Utilities.trim( self.txtMessage.text)
        
        if self.txtMessage.text == "" || self.txtMessage.text == placeHolderText {
            Utilities.showMessages(message: "Please enter comment")
        } else {
            self.view.endEditing(true)
            
            AlamofireModel.reachabilityCheck(isRecheable: {isRecheable in
                if isRecheable {
                    self.sendMessage(message: self.txtMessage.text!)
                    self.txtMessage.text = self.placeHolderText
                    self.cnstTextViewHeight.constant = 39.0
                    self.txtMessage.textColor = appColors.placeHolderText1
                } else {
                    AppInstance.showMessages(message: "Please check your connection")
                }
            })
        }
    }
}

extension ChatVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if self.txtMessage.text  == self.placeHolderText {
            self.txtMessage.text = ""
        }
        self.txtMessage.textColor = appColors.black1
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if self.txtMessage.text  == "" {
            self.txtMessage.text = placeHolderText
            self.txtMessage.textColor = appColors.placeHolderText1
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        let height = textView.contentSize.height
        if textView == self.txtMessage &&  self.cnstTextViewHeight.constant != height && height < 120.0  {
            self.cnstTextViewHeight.constant = height
            let bottom = NSMakeRange(0, 1)
            textView.scrollRangeToVisible(bottom)
            self.view.layoutIfNeeded()
        }

    }
}

extension ChatVC : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chat.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let temp = self.chat.list[indexPath.row]
        
        if temp.from_user_id == kCurrentUser.UserId
         {
            let cell : ChatSenderCell = tableView.dequeueReusableCell(withIdentifier: "ChatSenderCell", for: indexPath) as! ChatSenderCell
            cell.lblMessage.text = temp.message
            cell.lblTime.text = Utilities.customeDateTimeFormatter(doubleFromStr(temp.time),isChat: true)
            return cell
        }
        else
        {
            let cell : ChatReceiverCell = tableView.dequeueReusableCell(withIdentifier: "ChatReceiverCell", for: indexPath) as! ChatReceiverCell
            cell.lblMessage.text = temp.message
            cell.lblTime.text = Utilities.customeDateTimeFormatter(doubleFromStr(temp.time),isChat: true)
            return cell
        }
        
    }
    
}


extension ChatVC {
    
    func sendMessage(message: String)
    {
        let time = Int(Date().timeIntervalSince1970).description
        var chatKey = "\(kCurrentUser.UserId)_\(self.to_user_id)"
        
        if intFromStr(kCurrentUser.UserId)>intFromStr(self.to_user_id) {
            chatKey = "\(self.to_user_id)_\(kCurrentUser.UserId)"
        }
        
        let obj1 : [String:Any] =   ["user_id":  self.to_user_id,
                                     "user_name":self.to_user_name,
                                     "user_image":self.to_user_image,
                                     "last_chat_message":message,
                                     "last_chat_time": doubleFromStr(time),
                                     "last_chat_from_user_id": kCurrentUser.UserId
                                    
        ]
        
        let obj2 : [String:Any] =    ["user_id":kCurrentUser.UserId,
                                      "user_name":kCurrentUser.FullName,
                                      "user_image":kCurrentUser.ProfileImage,
                                      "last_chat_message":message,
                                      "last_chat_time":doubleFromStr(time),
                                      "last_chat_from_user_id": kCurrentUser.UserId
        ]
        
        let messageObj : [String:Any] =     ["message":message,
                                             "from_user_id":kCurrentUser.UserId,
                                             "time":doubleFromStr(time)]
        
        self.ref.child("chatlist").child(kCurrentUser.UserId).child(to_user_id).updateChildValues(obj1)
        self.ref.child("chatlist").child(to_user_id).child(kCurrentUser.UserId).updateChildValues(obj2)
        guard let key = self.ref.child("chat").child(chatKey).childByAutoId().key else { return }
        self.ref.child("chat").child(chatKey).child(key).setValue(messageObj)
        self.sendPushNotification(to: to_user_firebase_token, title: kCurrentUser.FullName, body: message)

    }
    
    func setChatListObjerver() {
        
        
        var chatKey = "\(kCurrentUser.UserId)_\(self.to_user_id)"
        if intFromStr(kCurrentUser.UserId)>intFromStr(self.to_user_id) {
            chatKey = "\(self.to_user_id)_\(kCurrentUser.UserId)"
        }
        

        self.chatRef = self.ref.child("chat").child(chatKey)
        
        self.chatRef.observe(.value, with: { (snapshot) in
            
            if snapshot.value != nil {
                let json = JSON(snapshot.value!)
                self.chat.list = []
                self.chat.update(json)
                self.chat.list.sort(by: {obj1,obj2 in
                    return doubleFromStr(obj1.time) > doubleFromStr(obj2.time)
                })
                //self.tableView.setContentOffset(CGPoint(x: 0, y: CGFloat.greatestFiniteMagnitude), animated: false)
                self.tableView.reloadData()
                
                if  self.chat.list.count > 0 {
                    self.setMessageCount(self.chat.list.count.description)
                }
                
            }
        })
        
        self.tokenRef = self.ref.child("firebase_token").child(to_user_id)
        
        self.tokenRef.observe(.value, with: { (snapshot) in
            
            if snapshot.value != nil {
                let json = JSON(snapshot.value!)
                self.to_user_firebase_token = strFromJSON(json["token"])
            }
        })
    }
    
    func setMessageCount(_ count: String) {
        
        let countObj : [String:Any] = ["total_message_count": intFromStr(count),
                                       "read_message_count": intFromStr(count)]
        let countObj2 : [String:Any] = ["total_message_count":intFromStr(count)]
        self.ref.child("chatlist").child(kCurrentUser.UserId).child(to_user_id).updateChildValues(countObj)
        self.ref.child("chatlist").child(to_user_id).child(kCurrentUser.UserId).updateChildValues(countObj2)
    }
    
    func sendPushNotification(to token: String, title: String, body: String) {
        
        if (token == "" || title == "" || body == "") {
            return
        }
            let urlString = "https://fcm.googleapis.com/fcm/send"
            let url = NSURL(string: urlString)!
            let paramString: [String : Any] = ["to" : token,
                                               "notification" : ["title" : title, "body" : body, "sound" : "audio.mp3"],
                                               "data" : ["notification_type" : "new_message","from_user_id": kCurrentUser.UserId]
            ]
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "POST"
            request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("key=AAAAkGnaWJM:APA91bH_A01scYkh2pCJs9MRz3PDEREpJZEOCHLGJ3J0qkL5HT4CVSe9MQUYz49RPcqfAOi7JJ6WO-4CSp4uizi3DtOj2WA53K_pU07v63TV9qufd0RTUKWmBTZCBR5GaEM3MGIJJboG", forHTTPHeaderField: "Authorization")
            let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
                do {
                    if let jsonData = data {
                        if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                            NSLog("Received data:\n\(jsonDataDict))")
                            print("Received data: ",jsonDataDict)
                        }
                    }
                } catch let err as NSError {
                    print(err.debugDescription)
                }
            }
            task.resume()
    }

}

// MARK: -  UICollectionViewDataSource, UICollectionViewDelegate Methods
extension ChatVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrSuggestedMessage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let chatSuggestionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatSuggestionCell", for: indexPath) as? ChatSuggestionCell else {
            return UICollectionViewCell()
        }
        chatSuggestionCell.prepareCell(suggestedMessage: arrSuggestedMessage[indexPath.item])
        return chatSuggestionCell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        txtMessage.text = arrSuggestedMessage[indexPath.item]
    }
}

//MARK: - UICollectionViewDelegateFlowLayout Methods
extension ChatVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let suggestedMessage = arrSuggestedMessage[indexPath.item]
        let size = suggestedMessage.size(withAttributes: [NSAttributedString.Key.font : UIFont(name: "", size: 12.0) ?? .systemFont(ofSize: 12.0)])
        return CGSize(width: size.width + 16.0, height: 25.0)
    }
}
