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
import CodableFirebase

struct FirestoreUserService: FirestoreUserServiceDelegate, FirestoreUserInfoDelegate {
    var db: Firestore
    init() {
        db = Firestore.firestore()
    }
    
    
    func userExists(delegate:SignUpViewControllerFirestoreDelegate, UserID:String){
        //https://stackoverflow.com/questions/46880323/how-to-check-if-a-cloud-firestore-document-exists-when-using-realtime-updates
        let usersRef = db.collection("Users").document(UserID)
        usersRef.getDocument { (document, error) in
            //var userExists = false
            if(document!.exists){//force-unwrap ok here?
                //go to tab bar
                delegate.userExists()
            }
            else{
                delegate.userDoesntExist()
            }
        }
        

    }
    
    func createUser(name: String, bitmojiURL:String, VC: UserInfoViewControllerFirestoreDelegate){
        let newUser = User(name: name, bitmojiURL: bitmojiURL, telephone: UserDefaults.standard.value(forKey: "Phone Number") as! String)
        let docData = try! FirestoreEncoder().encode(newUser)
        db.collection("Users").document(currUser.shared.currUsedID!).setData(docData){err in
            if let err = err {
                VC.showError(error: err.localizedDescription)
            }
            else{
                //go to next page/Bitmoji stuff
                //print("worked!")
                currUser.shared.bitmojiURL = URL(string: bitmojiURL)
                VC.succesfulCreateAccount()
            }
            
        }
    }
    
    func addMessageToFirestore(newMessage: Message){        //let diffInDays = Calendar.current.dateComponents([.day], from: Date(), to: Date())

        //db.collection("Users").document(currUserID!).collection("Videos").addDocument(data: <#T##[String : Any]#>, completion: <#T##((Error?) -> Void)?##((Error?) -> Void)?##(Error?) -> Void#>)
    }
    
    func loadCurrUserBitmojiURL(){
        //https://stackoverflow.com/questions/48312485/how-to-access-a-specific-field-from-cloud-firestore-firebase-in-swift
        if currUser.shared.bitmojiURL == nil{
            let docRef = db.collection("Users").document(currUser.shared.currUsedID!)
            
            docRef.getDocument { (document, error) in
                if let document = document{
                    currUser.shared.bitmojiURL = URL (string: document.get("bitmojiURL") as! String)
                }
                else{
                    print(error?.localizedDescription)
                }
            }
        }
    }
    
    //TODO:DELETE
    
    
    
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
    func loadCurrUserBitmojiURL()
}

protocol FirestoreUserInfoDelegate {
    func createUser(name: String, bitmojiURL:String, VC: UserInfoViewControllerFirestoreDelegate)
}
