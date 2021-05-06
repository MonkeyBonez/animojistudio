//
//  FirebaseAuthService.swift
//  AnimojiStudio
//  Snehal Mulchandani - Snehalmu@usc.edu

//  Created by Snehal Mulchandani on 4/23/21.
//

import Foundation
import FirebaseAuth

//to do auth with firebase
struct FirebaseAuthService: FirebaseSignUpDelegate, FirebaseSignOutDelegate{
    //once Verification code recieved, sign in
    func signInWithVerificationCode(verificationCode: String, viewController: SignUpViewControllerAuthDelegate) {
        guard let verificationID = getUserDefaultsVerificationID() else{
            viewController.showError(error: "Couldn't get verification ID :(")
            return
        }
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)
       // look through: https://firebase.google.com/docs/auth/ios/phone-auth?authuser=0
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                if (error.localizedDescription == "The SMS verification code used to create the phone auth credential is invalid. Please resend the verification code SMS and be sure to use the verification code provided by the user."){
                    viewController.showError(error: "Incorrect validation code - Please retry.")
                    //add retry functionality here get resent
                }
                else{
                    viewController.showError(error: error.localizedDescription)
                }
                return
            }
            /*print("success!") //toDelete
            print(authResult)
            print(Auth.auth().currentUser?.uid)*/
            //currUserID = Auth.auth().currentUser?.uid
            viewController.signInSuccess(userID: currUser.shared.currUsedID)
        }
    }
    
    //verify user's phone #
    func verifyPhone(phoneNumber: String, viewController: SignUpViewControllerAuthDelegate){
        Auth.auth().settings?.isAppVerificationDisabledForTesting = true
        setUserDefaultsPhoneNumber(phoneNumber: phoneNumber)
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
          if let error = error {
            //self.showMessagePrompt(error.localizedDescription)
            if(error.localizedDescription != "The interaction was cancelled by the user."){
                viewController.showError(error: error.localizedDescription)
            }
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
    //set auth Verification id so if user leaves app we still have it
    func setUserDefaultsVerificationID(verificationID: String){
        UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
    }
    //get auth verification id
    func getUserDefaultsVerificationID()->String?{
        return UserDefaults.standard.string(forKey: "authVerificationID")
    }
    //set phone number so we can always access it
    func setUserDefaultsPhoneNumber(phoneNumber: String){
        UserDefaults.standard.setValue(phoneNumber, forKey: "Phone Number")
    }
    //sign out from firebase auth -> Buggy
    func signOut(VC: SignoutViewControllerAuthDelegate) {
        do {
            try Auth.auth().signOut()
        } catch {
            VC.showError(error: "Could not sign out")
            return
        }
        VC.signOutSuccess()
    }
    
}
//to communicate to VC without exposing whole interface

protocol FirebaseSignUpDelegate{
    func signInWithVerificationCode(verificationCode: String, viewController: SignUpViewControllerAuthDelegate)
    mutating func verifyPhone(phoneNumber: String, viewController: SignUpViewControllerAuthDelegate)
}
//to communicate to VC without exposing whole interface

protocol FirebaseSignOutDelegate {
    func signOut(VC: SignoutViewControllerAuthDelegate)
}
