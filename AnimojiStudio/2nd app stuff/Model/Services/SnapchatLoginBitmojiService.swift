//
//  SnapchatLoginBitmojiService.swift
//  AnimojiStudio
//
//  Created by Snehal Mulchandani on 5/4/21.
//  Snehal Mulchandani - Snehalmu@usc.edu
//

import Foundation
import SCSDKLoginKit
//Service for getting bitmoji url and to handle snapchat login
class SnapchatLoginBitmojiService: SnapchatUserDataDelegate{
    var bitmojiAvatarUrl: String?
    
    //log in to snapchat
    func doSnapchatLogin(VC: SnapchatUserDataVC){
        //https://github.com/Snapchat/login-kit-sample
        SCSDKLoginClient.login(from: VC.getNavigationController()) { (success: Bool, error: Error?) in
            if success {
                self.getSnapchatBitmoji(VC: VC)
            }
            if let error = error {
                // Needs to be on the main thread to control the UI.
                DispatchQueue.main.async {
                    VC.showError(error: "Login Failed")
                }
            }
        }
    }
    //get user's bitmoji
    func getSnapchatBitmoji(VC: SnapchatUserDataVC){
        //https://kit.snapchat.com/docs/login-kit-ios
        let graphQLQuery = "{me{bitmoji{avatar}}}"
        let variables = ["page": "bitmoji"]
        SCSDKLoginClient.fetchUserData(withQuery: graphQLQuery, variables: variables) { (resources: [AnyHashable : Any]?) in
            guard let resources = resources else{
                VC.showError(error: "Failed to get Bitmoji")
                return
            }
            let data = resources["data"] as? [String: Any]
            guard let me = data?["me"] as? [String: Any] else { return }
            if let bitmoji = me["bitmoji"] as? [String: Any] {
                self.bitmojiAvatarUrl = bitmoji["avatar"] as? String
                print(bitmoji["avatar"] as? String)
            }
        } failure: { (error: Error?, isUserLoggedOut: Bool) in
            VC.showError(error: error?.localizedDescription ?? "Relogin to snapchat")
        }


    }
}
//to communicate to VC without exposing whole interface

protocol SnapchatUserDataDelegate {
    var bitmojiAvatarUrl: String? { get set }
    mutating func doSnapchatLogin(VC: SnapchatUserDataVC)
}
