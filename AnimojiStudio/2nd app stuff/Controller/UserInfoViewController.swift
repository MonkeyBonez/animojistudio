//
//  UserInfoViewController.swift
//  AnimojiStudio
//
//  Created by Snehal Mulchandani on 5/2/21.
//  Snehal Mulchandani - Snehalmu@usc.edu

//

import UIKit
import SCSDKLoginKit

//Gets users info if they don have an account
class UserInfoViewController: ShowsErrorHideKeyboardGIFBackgroundViewController, UserInfoViewControllerFirestoreDelegate,SnapchatUserDataVC {

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    var userInfoDelegate:FirestoreUserInfoDelegate!
    var bitmojiAvatarUrl:String?
    var snapchatDelegate: SnapchatUserDataDelegate = SnapchatLoginBitmojiService()

    //set GIF background needed and service delegate
    override func viewDidLoad() {
        backgroundImageName = "Background2"
        backgroundImage = imageView
        self.keyboardsToHide = [nameTextField]
        userInfoDelegate = FirestoreUserService()
        super.viewDidLoad()
        //loadBackground()
        // Do any additional setup after loading the view.
    }
    //hand off connect bitmoji task to delegate
    @IBAction func connectBitmojiButtonPressed(_ sender: Any) {
        snapchatDelegate.doSnapchatLogin(VC: self)
    }
    
    
    //check to make sure inputs (name and bitmoji) are correct then hand off to delegate with preprocessed name or error if needed
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
    //preprocesses name input
    func preprocessInputs(input: String) -> String{//goes in model?
        return input.trimmingCharacters(in: CharacterSet(arrayLiteral: " "))
    }
    //output the input error... my enjoyment for writing minimal code seems psychopathic here
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
    //if delegate informs that we succesfully created an account, let app delegate know which will handle
    func succesfulCreateAccount() {
        (UIApplication.shared.delegate as! AppDelegate).userExists()
    }
    //to help delegate as it needs current navigation controller to log into snap
    func getNavigationController() -> UINavigationController {
        return self.navigationController!
    }

}
//to communicate to delegate without exposing whole VC interface
protocol UserInfoViewControllerFirestoreDelegate: CanShowErrorProtocol {
    func succesfulCreateAccount()
}

//to communicate to delegate without exposing whole VC interface
protocol SnapchatUserDataVC: CanShowErrorProtocol {
    func getNavigationController() -> UINavigationController
}
