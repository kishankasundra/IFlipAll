//
//  SellProductVC.swift
//  IFlipAll
//
//  Created by devangs.bhatt on 12/06/21.
//  Copyright © 2021 StarkTechnolabs. All rights reserved.
//

import UIKit

class SellProductVC: UIViewController {
   
    @IBOutlet weak var tblSellProducts: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.async {
            self.tblSellProducts.dataSource = self
            self.tblSellProducts.delegate = self
            self.tblSellProducts.reloadData()
        }
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}

extension SellProductVC {
    
}


// MARK: -  UITableViewDataSource, UITableViewDelegate Methods
extension SellProductVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sellProductCell = tableView.dequeueReusableCell(withIdentifier: "SellProductTableViewCell", for: indexPath) as? SellProductTableViewCell else {
            return UITableViewCell()
        }
        
        return sellProductCell
    }
}

