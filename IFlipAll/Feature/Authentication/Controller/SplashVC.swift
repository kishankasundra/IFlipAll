//
//  SplashVC.swift
//  IFlipAll
//
//  Created by kishan kasundra on 07/12/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit

class SplashVC: UIViewController {

    @IBOutlet weak var imgLogo: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadGIF()
       // self.imgLogo.rotate(duration: 3)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [unowned self] in
            
            if kCurrentUser.UserId != ""
            {
                let resultVC : HomeVC = Utilities.viewController(name: "HomeVC", storyboard: "Home") as! HomeVC
                self.navigationController?.pushViewController(resultVC, animated: true)
            }
            else
            {
                let resultVC : LoginVC = Utilities.viewController(name: "LoginVC", storyboard: "Authentication") as! LoginVC
                self.navigationController?.pushViewController(resultVC, animated: true)
            }
        
            
        }

        // Do any additional setup after loading the view.
    }
    

    func loadGIF() {
        let gif = UIImage.gifImageWithName("splash")
        let imageView = UIImageView(image: gif)
        imageView.frame = CGRect(x: 0.0, y: 0.0, width: ScreenWidth, height: ScreenHeight)
        self.view.addSubview(imageView)
    }

}

extension UIView {
    private static let kRotationAnimationKey = "rotationanimationkey"

    func rotate(duration: Double = 1) {
        if layer.animation(forKey: UIView.kRotationAnimationKey) == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")

            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Float.pi * 2.0
            rotationAnimation.duration = duration
            rotationAnimation.repeatCount = Float.infinity

            layer.add(rotationAnimation, forKey: UIView.kRotationAnimationKey)
        }
    }

    func stopRotating() {
        if layer.animation(forKey: UIView.kRotationAnimationKey) != nil {
            layer.removeAnimation(forKey: UIView.kRotationAnimationKey)
        }
    }
}
