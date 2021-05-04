//
//  UserInfoViewController.swift
//  AnimojiStudio
//
//  Created by Snehal Mulchandani on 5/2/21.

//

import UIKit
import SCSDKLoginKit

//add activity indicator stuff
class UserInfoViewController: ShowsErrorHideKeyboardGIFBackgroundViewController, UserInfoViewControllerFirestoreDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    var userInfoDelegate:FirestoreUserInfoDelegate!

    
    override func viewDidLoad() {
        backgroundImageName = "Background2"
        backgroundImage = imageView
        self.keyboardsToHide = [nameTextField]
        userInfoDelegate = FirestoreUserService()
        super.viewDidLoad()
        //loadBackground()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func connectBitmojiButtonPressed(_ sender: Any) {//broken
        SCSDKLoginClient.login(from: self, completion: { success, error in

                if let error = error {
                    print(error.localizedDescription)
                    return
                }

                if success {
                    print("EUREKA!")//example code
                }
            })
    }
    
    
    
    
    @IBAction func enterButtonPressed(_ sender: Any) {
        //input preprocessing
        var nameError = false
        let preprocessedName = preprocessInputs(input: nameTextField.text ?? " ")
        if(preprocessedName.isEmpty){
            nameError = true
        }
        else{
            userInfoDelegate.createUser(name: preprocessedName, VC: self)
        }
        
        //check all errors and call input error to inform user
        if(nameError){
            inputError(nameError: nameError)
        }
    }
    
    func preprocessInputs(input: String) -> String{//goes in model?
        return input.trimmingCharacters(in: CharacterSet(arrayLiteral: " "))
    }
    
    func inputError(nameError: Bool){//create bools for other errors
        showError(error: "Please enter your name")
    }
    
    func succesfulCreateAccount() {
        (UIApplication.shared.delegate as! AppDelegate).userExists()
    }

}

protocol UserInfoViewControllerFirestoreDelegate: CanShowErrorProtocol {
    func succesfulCreateAccount()
}
