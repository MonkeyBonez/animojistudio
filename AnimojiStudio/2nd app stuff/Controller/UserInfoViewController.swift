//
//  UserInfoViewController.swift
//  AnimojiStudio
//
//  Created by Snehal Mulchandani on 5/2/21.

//

import UIKit
import SCSDKLoginKit

//add activity indicator stuff
class UserInfoViewController: ShowsErrorHideKeyboardGIFBackgroundViewController, UserInfoViewControllerFirestoreDelegate,SnapchatUserDataVC {

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    var userInfoDelegate:FirestoreUserInfoDelegate!
    var bitmojiAvatarUrl:String?
    var snapchatDelegate: SnapchatUserDataDelegate = SnapchatLoginBitmojiService()

    
    override func viewDidLoad() {
        backgroundImageName = "Background2"
        backgroundImage = imageView
        self.keyboardsToHide = [nameTextField]
        userInfoDelegate = FirestoreUserService()
        super.viewDidLoad()
        //loadBackground()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func connectBitmojiButtonPressed(_ sender: Any) {
        snapchatDelegate.doSnapchatLogin(VC: self)
    }
    
    
    
    @IBAction func enterButtonPressed(_ sender: Any) {
        //input preprocessing
        var nameError:Bool
        var bitmojiError: Bool
        let preprocessedName = preprocessInputs(input: nameTextField.text ?? " ")
        if(preprocessedName.isEmpty){
            nameError = true
        }
        else{
            nameError = false
        }
        
        if let bitmojiURL = snapchatDelegate.bitmojiAvatarUrl {
            bitmojiError = false
        }
        else{
            bitmojiError = true
        }
        
        //check all errors and call input error to inform user
        if(nameError || bitmojiError){
            inputError(nameError: nameError, bitmojiError: bitmojiError)
        }
        else{//update
            userInfoDelegate.createUser(name: preprocessedName, bitmojiURL: snapchatDelegate.bitmojiAvatarUrl!, VC: self)
        }
    }
    
    func preprocessInputs(input: String) -> String{//goes in model?
        return input.trimmingCharacters(in: CharacterSet(arrayLiteral: " "))
    }
    
    func inputError(nameError: Bool, bitmojiError:Bool){//create bools for other errors
        var errorToShow = "Please "
        if(nameError){
            errorToShow += "enter your name"
            if(bitmojiError){
                errorToShow += " and "
            }
        }
        if(bitmojiError){
            errorToShow += "link your bitmoji"
        }
        showError(error: errorToShow)
    }
    
    func succesfulCreateAccount() {
        (UIApplication.shared.delegate as! AppDelegate).userExists()
    }
    
    func getNavigationController() -> UINavigationController {
        return self.navigationController!
    }

}

protocol UserInfoViewControllerFirestoreDelegate: CanShowErrorProtocol {
    func succesfulCreateAccount()
}

protocol SnapchatUserDataVC: CanShowErrorProtocol {
    func getNavigationController() -> UINavigationController
}
