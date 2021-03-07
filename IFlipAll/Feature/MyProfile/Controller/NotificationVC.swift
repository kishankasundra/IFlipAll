//
//  NotificationVC.swift
//  IFlipAll
//
//  Created by kishan on 28/11/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit

class NotificationVC: UIViewController {

    @IBOutlet weak var tableViewNotification: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tableViewNotification.estimatedRowHeight = 80
        tableViewNotification.rowHeight = UITableView.automaticDimension
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
           self.navigationController?.popViewController(animated: true)
       }
   
}

extension NotificationVC : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : NotificationTBLCell = tableView.dequeueReusableCell(withIdentifier: "NotificationTBLCell", for: indexPath) as! NotificationTBLCell
        
        return cell
    }
}
