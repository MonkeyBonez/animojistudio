//
//  SignUpViewController.swift
//  AnimojiStudio
//
//  Created by Snehal Mulchandani on 4/21/21.
//

import UIKit
//toDO: Give up first responder when appropriate
class SignUpViewController: GifBackgroundViewController, SignUpViewControllerDelegate, UITextFieldDelegate {
    var signUpDelegate:FirebaseSignUpDelegate = FirebaseAuthService()

    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var shootingStarImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundImageName = "Background"
        self.loadBackground()
        self.loadGif(for: "shootingStar", image: shootingStarImageView)
        let screenTap = UITapGestureRecognizer(target: self, action: #selector(screenTapped))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(screenTap)
    }
    
    @objc func screenTapped(){
        phoneNumberTextField.resignFirstResponder()
    }
    
    
    
    func showError(error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let continueAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(continueAction)
        self.present(alert, animated: false)
    }
    
    
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
}

protocol SignUpViewControllerDelegate {
    func showError(error: String)
    func getVerificationCode()
}
