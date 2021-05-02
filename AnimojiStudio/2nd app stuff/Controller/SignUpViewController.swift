//
//  SignUpViewController.swift
//  AnimojiStudio
//
//  Created by Snehal Mulchandani on 4/21/21.
//

import UIKit
//toDO: Give up first responder when appropriate
class SignUpViewController: ShowsErrorHideKeyboardGIFBackgroundViewController, SignUpViewControllerAuthDelegate, UITextFieldDelegate, SignUpViewControllerFirestoreDelegate {
    
    
    let signUpDelegate:FirebaseSignUpDelegate = FirebaseAuthService() //change to same as below?
    var userServiceDelegate:FirestoreUserServiceDelegate!

    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var shootingStarImageView: UIImageView!
    override func viewDidLoad() {
        self.backgroundImageName = "Background"
        //self.loadBackground()
        self.loadGif(for: "shootingStar", image: shootingStarImageView)
        self.keyboardsToHide = [phoneNumberTextField]
        super.viewDidLoad()
    }
    

    
    /*override func viewDidAppear(_ animated: Bool) {
        hideNavigationBar(animated: animated)
    }*/
    
    
    
    
    
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        //verify/preprocess inputs
        if(phoneNumberTextField.text!.isEmpty){
            showError(error: "Please enter your phone number")
        }
        else if(phoneNumberTextField.text!.count == 7){
            showError(error: "Please enter your area code")
        }
        else if (phoneNumberTextField.text!.count != 10){
            showError(error: "Please enter your 10 digit US phone number")
        }
        else{
        signUpDelegate.verifyPhone(phoneNumber: "+1" + phoneNumberTextField.text!, viewController: self)//check if ! messes up for empty
        }
    }
    
    func getVerificationCode(){
        let alert = UIAlertController(title: "Verify Phone Number", message: "Provide verification code", preferredStyle: .alert)
        let continueAction = UIAlertAction(title: "Ok", style: .default) { (actionPerformed) in
            guard let verificationCode = alert.textFields?.first?.text, !verificationCode.isEmpty else{
                self.showError(error: "Verification code not input")
                return
            }
            self.signUpDelegate.signInWithVerificationCode(verificationCode: verificationCode, viewController: self)
        }
        alert.addAction(continueAction)
        
        alert.addTextField { (textField) in
            //textField.keyboardType = .default
            textField.textContentType = .oneTimeCode
            textField.placeholder = "Verification Code"
            textField.delegate = self
        }
        present(alert, animated: false)
    }
    func signInSuccess(userID: String?) {
        //check if user exists, push to account creation else tab bar w/map
        if let userID = userID{
            userServiceDelegate.userExists(delegate: self, UserID: userID)
        }
    }
    
    func userExists() {
        
    }
    
    func userDoesntExist() {
        
    }
    
}

protocol SignUpViewControllerAuthDelegate: CanShowErrorProtocol {
    func getVerificationCode()
    func signInSuccess(userID: String?)
}

protocol SignUpViewControllerFirestoreDelegate {
    func userExists()
    func userDoesntExist()
    //change to userExists and userDoesn'tExist
}
