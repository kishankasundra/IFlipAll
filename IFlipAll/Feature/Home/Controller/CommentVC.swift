//
//  CommentVC.swift
//  IFlipAll
//
//  Created by kishan on 29/11/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit

class CommentVC: UIViewController {
    
    @IBOutlet weak var tblViewCommentList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tblViewCommentList.estimatedRowHeight = 80
        tblViewCommentList.rowHeight = UITableView.automaticDimension
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension CommentVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : CommentListTBLCell = tableView.dequeueReusableCell(withIdentifier: "CommentListTBLCell", for: indexPath) as! CommentListTBLCell
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let resultVC : RateThisOfferVC = Utilities.viewController(name: "RateThisOfferVC", storyboard: "Home") as! RateThisOfferVC
        self.present(resultVC, animated: false, completion: nil)
    }
    
}
