//
//  FirebaseAuthService.swift
//  AnimojiStudio
//
//  Created by Snehal Mulchandani on 4/23/21.
//

import Foundation
import FirebaseAuth


struct FirebaseAuthService: FirebaseSignUpProtocol{
    func signInWithVerificationCode(verificationCode: String, viewController: FirebaseSignUpVCProtocol) {
        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else{
            viewController.showError(error: "Couldn't get verification ID :(")
            return
        }
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)
       // look through: https://firebase.google.com/docs/auth/ios/phone-auth?authuser=0
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                viewController.showError(error: error.localizedDescription)
                return
            }
            print("success!") //toDelete
            print(authResult)
        }
    }
    
    func signUp(email:String, password:String){
       // Auth.auth().createUser(withEmail: <#T##String#>, password: <#T##String#>, completion: <#T##((AuthDataResult?, Error?) -> Void)?##((AuthDataResult?, Error?) -> Void)?##(AuthDataResult?, Error?) -> Void#>)
    }
    
    func verifyPhone(phoneNumber: String, viewController: FirebaseSignUpVCProtocol){
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
          if let error = error {
            //self.showMessagePrompt(error.localizedDescription)
            viewController.showError(error: error.localizedDescription)
            return
          }
          // Sign in using the verificationID and the code sent to the user
          // ...
            if let verificationID = verificationID{
                self.setUserDefaultsVerificationID(verificationID: verificationID)
                viewController.getVerificationCode()
                //get SMS verification Code
                //set verification ID after
                //create user in firestore after
            }
        }
    }
    
    func setUserDefaultsVerificationID(verificationID: String){
        UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
    }
}

protocol FirebaseSignUpProtocol{
    func signInWithVerificationCode(verificationCode: String, viewController: FirebaseSignUpVCProtocol)
    func verifyPhone(phoneNumber: String, viewController: FirebaseSignUpVCProtocol)
}
