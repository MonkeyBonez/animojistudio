//
//  AppDelegate.swift
//  Ar2
//
//  Created by Snehal Mulchandani on 4/17/21.
//

import UIKit
import Firebase

//Global
var recordingFlowController = RecordingFlowController()
var currUserID: String?

@main
class AppDelegate: UIResponder, UIApplicationDelegate, SignUpViewControllerFirestoreDelegate {
    

    var window: UIWindow?
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // set up notification center here

        FirebaseApp.configure()
        
        recordingFlowController = RecordingFlowController()
        MemojiSupport.prepareMemojiRuntime()
        recordingFlowController.supportsMemoji = MemojiSupport.deviceSupportsMemoji()
        currUserID = Firebase.Auth.auth().currentUser?.uid
        if let currUserID = currUserID{
            let userServiceDelegate:FirestoreUserServiceDelegate = FirestoreUserService()
            userServiceDelegate.userExists(delegate: self, UserID: currUserID)
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func userExists() {
        //set root VC to tab bar w/ map
    }
    
    func userDoesntExist() {
        //set root VC to Sign up info screen
        //https://stackoverflow.com/questions/10428629/programmatically-set-the-initial-view-controller-using-storyboards?noredirect=1&lq=1
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        //navigationController.view.frame = self.window!.bounds
        let rootViewController = storyboard.instantiateViewController(withIdentifier: "UserInfoVC") as UIViewController
            navigationController.viewControllers = [rootViewController]
        
            self.window?.rootViewController = navigationController
    }


}

