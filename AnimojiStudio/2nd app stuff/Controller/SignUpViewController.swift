//
//  SignUpViewController.swift
//  AnimojiStudio
//
//  Created by Snehal Mulchandani on 4/21/21.
//

import UIKit
//toDO: Give up first responder when appropriate
class SignUpViewController: GifBackgroundViewController, FirebaseSignUpVCProtocol, UITextFieldDelegate {
    var signInService:FirebaseSignUpProtocol = FirebaseAuthService()

    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundImageName = "Background2"
        self.loadBackground()
    }
    
    @IBAction func keyboardDonePressed(_ sender: Any) {
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
        signInService.verifyPhone(phoneNumber: phoneNumberTextField.text!, viewController: self)//check if ! messes up for empty
    }
    
    func getVerificationCode(){
        let alert = UIAlertController(title: "Verify Phone Number", message: "Provide verification code", preferredStyle: .alert)
        let continueAction = UIAlertAction(title: "Ok", style: .default) { (actionPerformed) in
            guard let verificationCode = alert.textFields?.first?.text, !verificationCode.isEmpty else{
                self.showError(error: "Verification code not input")
                return
            }
            self.signInService.signInWithVerificationCode(verificationCode: verificationCode, viewController: self)
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

protocol FirebaseSignUpVCProtocol {
    func showError(error: String)
    func getVerificationCode()
}
