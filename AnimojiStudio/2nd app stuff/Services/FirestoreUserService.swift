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

struct FirestoreUserService: FirestoreUserServiceDelegate {
    let db = Firestore.firestore()
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
    
}

protocol FirestoreUserServiceDelegate {
    func userExists(delegate:SignUpViewControllerFirestoreDelegate, UserID:String)
}
