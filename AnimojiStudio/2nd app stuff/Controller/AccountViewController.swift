//
//  AccountViewController.swift
//  AnimojiStudio
//
//  Created by Snehal Mulchandani on 5/4/21.
//  Snehal Mulchandani - Snehalmu@usc.edu
//

import UIKit
//VC for viewing your own profile to follow others or log out
class AccountViewController: ShowsErrorHideKeyboardGIFBackgroundViewController, SignoutViewControllerAuthDelegate {

    @IBOutlet weak var GIFImageBackgroundView: UIImageView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    var signOutDelegate: FirebaseSignOutDelegate!
    
    //set up the delegate and background image
    override func viewDidLoad() {
        signOutDelegate = FirebaseAuthService()
        self.backgroundImage = GIFImageBackgroundView
        self.backgroundImageName = "accountPageGif"
        super.viewDidLoad()
        setProfileBitmojiPicture()
        //self.tabBarController?.tabBar.backgroundImage = UIImage()
        // Do any additional setup after loading the view.
    }
    
    //set user's bitmoji profile pic at this point in the currUser singelton as we need it whenever user creates message and
    func setProfileBitmojiPicture(){
        do {
            try profileImageView.image = UIImage(data: NSData(contentsOf: currUser.shared.bitmojiURL!) as Data)
        } catch {
            return
        }
    }
    
//let delegate handle sign out if sign out button pressed
    @IBAction func logoutButtonPressed(_ sender: Any) {
        signOutDelegate.signOut(VC: self)
    }
    //go to the view controller to add friends if add friends button pressed
    @IBAction func addFriendsButtonPressed(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: .main).instantiateViewController(identifier: "AddFriendsVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //once user is succesfully logged out and we are informed by app delegate, set sign in page to the Root VC
    func signOutSuccess() {
        //code is repeated from App delegate... how to fix?
        // is this ok?
        (UIApplication.shared.delegate as! AppDelegate).signInPage()
    }

}

//to communicate to delegate without exposing whole VC interface
protocol SignoutViewControllerAuthDelegate: CanShowErrorProtocol {
    func signOutSuccess()
}
