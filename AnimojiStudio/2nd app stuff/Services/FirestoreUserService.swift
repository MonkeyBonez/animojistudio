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
import FirebaseStorage


struct FirestoreUserService: FirestoreUserServiceDelegate, FirestoreUserInfoDelegate {
    var db: Firestore
    init() {
        db = Firestore.firestore()
    }
    func userExists(delegate:SignUpViewControllerFirestoreDelegate, UserID:String){
        //https://stackoverflow.com/questions/46880323/how-to-check-if-a-cloud-firestore-document-exists-when-using-realtime-updates
        let usersRef = db.collection("Users").document(UserID)
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
                VC.succesfulCreateAccount()
            }
            
        }
    }
    
    //TODO:DELETE
    func createVideo(url: String){
        
        //db.collection("Users").document(currUserID!).collection("Videos").addDocument(data: <#T##[String : Any]#>, completion: <#T##((Error?) -> Void)?##((Error?) -> Void)?##(Error?) -> Void#>)
    }
    
    
    /*func uploadVideo(){
        //db.collection("Users").document(currUserID!).collection("Videos").addDocument(data: <#T##[String : Any]#>, completion: <#T##((Error?) -> Void)?##((Error?) -> Void)?##(Error?) -> Void#>)
        var videoURL: NSURL = NSURL(fileURLWithPath: "hi/hi") //delete
        let storageRef = StorageReference()
        let videoName = currUserID! + String(Date().timeIntervalSince1970)
        let videoRef = storageRef.child("Videos/\(videoName)")
        let videoFile:URL = videoURL.absoluteURL!
        
        let uploadTask = videoRef.putFile(from: videoFile, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else{
                print("Couldn't upload " + error!.localizedDescription)
                return
            }
            videoRef.downloadURL { (url, error) in
                guard let url = url else{
                    print("Eror: " + error!.localizedDescription)
                    return
                }
                print(url)
            }
        }
    }*/
    
}

protocol FirestoreUserServiceDelegate {
    func userExists(delegate:SignUpViewControllerFirestoreDelegate, UserID:String)
}

protocol FirestoreUserInfoDelegate {
    func createUser(name: String, VC: UserInfoViewControllerFirestoreDelegate)
}
