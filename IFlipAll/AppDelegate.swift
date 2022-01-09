//
//  AppDelegate.swift
//  IFlipAll
//
//  Created by kishan on 22/11/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import NVActivityIndicatorView
import GoogleSignIn
import AWSS3
import Firebase

var AppInstance : AppDelegate!
var locationManager = CLLocationManager()
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
       
        AppInstance = self
        
        self.initializeS3()
        
        GIDSignIn.sharedInstance()?.clientID = "620251207827-rlq0jqp8re3cija8l2u387iqiuacs7hj.apps.googleusercontent.com"
       // sleep(3)
        IQKeyboardManager.shared.enable = true
        FirebaseApp.configure()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        return true
    }
    
    func initializeS3() {
        
       // let credentialsProvider = AWSCognitoCredentialsProvider(regionType: regionType, identityPoolId: poolId)
        
        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: accessKey, secretKey: secretAccess)
        
        let configuration = AWSServiceConfiguration(region: regionType, credentialsProvider: credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!)
    {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("user has disconnect")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func topVC() -> UIViewController?
          {
              
              if var topController = self.window!.rootViewController {
                  
                  while let presentedViewController = topController.presentedViewController
                  {
                      topController = presentedViewController
                  }
                  
                  return topController
                  // topController should now be your topmost view controller
              }
              
              return nil
              
          }
       
    
    var loader: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
    let bgView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    let indi = NVActivityIndicatorView(frame: CGRect(x: (ScreenWidth / 2) - 15, y: (ScreenHeight / 2) - 15, width: 30, height: 30), type: .lineScalePulseOutRapid , color: .gray, padding: 0)
    
    func showLoader()
    {
        if let vc = self.topVC()
        {
            bgView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
            //vc.view.addSubview(bgView)
            vc.view.addSubview(indi)
            indi.startAnimating()
            self.window!.isUserInteractionEnabled = false
            
        }
    }
    
    func hideLoader()
    {
        self.window!.isUserInteractionEnabled = true
        //bgView.removeFromSuperview()
        indi.stopAnimating()
        indi.removeFromSuperview()
        
    }
    
    func showMessages(message : String)
    {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default, handler: {_ in
            
            
        })
        
        alert.addAction(action)
        
        self.window!.rootViewController!.present(alert, animated: true, completion: nil)
    }
    
    func getCurrentLocation() -> CLLocationCoordinate2D?
    {
        if let loc = locationManager.location
        {
            return CLLocationCoordinate2D(latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude)
        }
        else
        {
            return nil
        }
    }
}
