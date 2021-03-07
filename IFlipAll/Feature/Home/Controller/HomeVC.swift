//
//  HomeVC.swift
//  IFlipAll
//
//  Created by kishan on 25/11/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit

var selectedTab : Int = 0
class HomeVC: UIViewController {

    @IBOutlet weak var scrollContainer: UIScrollView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imgHome: UIImageView!
    //@IBOutlet weak var imgSell: UIImageView!
    @IBOutlet weak var imgProfile: UIImageView!
    
    let homeTabVC : HomeTabVC = Utilities.viewController(name: "HomeTabVC", storyboard: "Home") as! HomeTabVC
    
    
    let postAnItemTabVC : PostAnItemTabVC = Utilities.viewController(name: "PostAnItemTabVC", storyboard: "Home") as! PostAnItemTabVC
    
    let myProfileTabVC : MyProfileTabVC = Utilities.viewController(name: "MyProfileTabVC", storyboard: "Home") as! MyProfileTabVC
    
    var isFirstTime : Bool = true

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setPlaceHolder()
        self.scrollContainer.isScrollEnabled = false
        UIApplication.shared.statusBarStyle = .lightContent
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !self.isFirstTime {
            self.changeTabColor()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.isFirstTime
        {
            self.isFirstTime = !self.isFirstTime
            self.addChildVC()
            self.changeTabColor()
        }
        
    }
    
    @IBAction func btnTabActions(_ sender: UIButton) {
        selectedTab = sender.tag
        self.changeTabColor()
    }
    

    func changeTabColor()
    {
        self.scrollContainer.setContentOffset(CGPoint(x: CGFloat(selectedTab) * ScreenWidth, y: 0), animated: false)
        
        self.imgHome.tintColor = appColors.gray
        //self.imgSell.tintColor = appColors.gray
        self.imgProfile.tintColor = appColors.gray
        
        switch selectedTab {
            
                case 0:
                    self.imgHome.tintColor = appColors.green
                    //self.lblDashboardTitle.text = "Dashboard"
                    //?self.homeTabVC.messagesVCTabClick()
                    break
                case 1:
                    //self.imgSell.tintColor = appColors.green
                    //self.lblDashboardTitle.text = "My Account"
                    //self.qrCodeTabVC.qrCodeTabTapped()
                    //self.gymVC.gymVCTabClick()
                    break
                case 2:
                    self.imgProfile.tintColor = appColors.green
                    //self.imgMyApplication.tintColor = appColors.textDudhiya
                    //self.lblDashboardTitle.text = "My Applications"
                    //self.profileVC.profileVCTabClick()
                    break
            
                default:
                    print("error")
        }
    }

    func addChildVC()
       {
           var height = ScreenHeight //- Utilities.statusBarHeight()

           if #available(iOS 11.0, *) {
               let window = UIApplication.shared.keyWindow
               let topPadding = window?.safeAreaInsets.top
               let bottomPadding = window?.safeAreaInsets.bottom
               height = ScreenHeight - bottomPadding! - topPadding! - 64
           }

                   self.viewContainer.addSubview(self.homeTabVC.view)
                   self.homeTabVC.view.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: height)
                   self.homeTabVC.didMove(toParent: self)
                   self.addChild(self.homeTabVC)

                   self.viewContainer.addSubview(self.postAnItemTabVC.view)
                   self.postAnItemTabVC.view.frame = CGRect(x: ScreenWidth, y: 0, width: ScreenWidth, height: height)
                   self.postAnItemTabVC.didMove(toParent: self)
                   self.addChild(self.postAnItemTabVC)
                 
                   self.viewContainer.addSubview(self.myProfileTabVC.view)
                   self.myProfileTabVC.view.frame = CGRect(x: 2*ScreenWidth, y: 0, width: ScreenWidth, height: height)
                   self.myProfileTabVC.didMove(toParent: self)
                   self.addChild(self.myProfileTabVC)


       }

    
    func setPlaceHolder() {
        imgHome.image = imgHome.image?.withRenderingMode(.alwaysTemplate)
        //imgSell.image = imgSell.image?.withRenderingMode(.alwaysTemplate)
        imgProfile.image = imgProfile.image?.withRenderingMode(.alwaysTemplate)
    }
}

