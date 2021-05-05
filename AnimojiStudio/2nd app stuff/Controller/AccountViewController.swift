//
//  AccountViewController.swift
//  AnimojiStudio
//
//  Created by Snehal Mulchandani on 5/4/21.
//  Copyright © 2021 Guilherme Rambo. All rights reserved.
//

import UIKit

class AccountViewController: ShowsErrorHideKeyboardGIFBackgroundViewController, SignoutViewControllerAuthDelegate {

    @IBOutlet weak var GIFImageBackgroundView: UIImageView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    var signOutDelegate: FirebaseSignOutDelegate!
    
    override func viewDidLoad() {
        signOutDelegate = FirebaseAuthService()
        self.backgroundImage = GIFImageBackgroundView
        self.backgroundImageName = "accountPageGif"
        super.viewDidLoad()
        setProfileBitmojiPicture()
        //self.tabBarController?.tabBar.backgroundImage = UIImage()
        // Do any additional setup after loading the view.
    }
    
    func setProfileBitmojiPicture(){
        do {
            try profileImageView.image = UIImage(data: NSData(contentsOf: currUser.shared.bitmojiURL!) as Data)
        } catch {
            return
        }
    }
    

    @IBAction func logoutButtonPressed(_ sender: Any) {
        signOutDelegate.signOut(VC: self)
    }
    
    @IBAction func addFriendsButtonPressed(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: .main).instantiateViewController(identifier: "AddFriendsVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func signOutSuccess() {
        //code is repeated from App delegate... how to fix?
        // is this ok?
        (UIApplication.shared.delegate as! AppDelegate).signInPage()
    }

}

protocol SignoutViewControllerAuthDelegate: CanShowErrorProtocol {
    func signOutSuccess()
}
