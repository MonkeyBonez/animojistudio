//
//  FirestoreUserService.swift
//  AnimojiStudio
//
//  Created by Snehal Mulchandani on 5/1/21.
//  Copyright © 2021 Guilherme Rambo. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore


struct FirestoreUserService: FirestoreUserServiceDelegate, FirestoreUserInfoDelegate {
    var db: Firestore
    init() {
        db = Firestore.firestore()
    }
    func userExists(delegate:SignUpViewControllerFirestoreDelegate, UserID:String){
        //https://stackoverflow.com/questions/46880323/how-to-check-if-a-cloud-firestore-document-exists-when-using-realtime-updates
        let usersRef = db.collection("users").document(UserID)
        usersRef.getDocument { (document, error) in
            var userExists = false
            if(document!.exists){//force-unwrap ok here?
                //go to tab bar
                delegate.userExists()
            }
            else{
                delegate.userDoesntExist()
            }
        }
        

    }
    
    func createUser(name: String, VC: UserInfoViewControllerFirestoreDelegate){
        
        db.collection("Users").document(currUserID!).setData([
            "name": name
        ]){err in
            if let err = err {
                VC.showError(error: err.localizedDescription)
            }
            else{
                //go to next page/Bitmoji stuff
                print("worked!")
            }
            
        }
    }
    
}

protocol FirestoreUserServiceDelegate {
    func userExists(delegate:SignUpViewControllerFirestoreDelegate, UserID:String)
}

protocol FirestoreUserInfoDelegate {
    func createUser(name: String, VC: UserInfoViewControllerFirestoreDelegate)
}
