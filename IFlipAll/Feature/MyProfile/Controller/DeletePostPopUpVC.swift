//
//  DeletePostPopUpVC.swift
//  IFlipAll
//
//  Created by kishan on 29/11/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit

class DeletePostPopUpVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnNoAction(_ sender: UIButton) {
           dismiss(animated: false, completion: nil)
       }
    
    @IBAction func btnYesAction(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }

}
