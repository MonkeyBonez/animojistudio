//
//  FirestoreUserService.swift
//  AnimojiStudio
//
//  Created by Snehal Mulchandani on 5/1/21.
//  Snehal Mulchandani - Snehalmu@usc.edu
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import CodableFirebase
//to create user and check if they exist
struct FirestoreUserService: FirestoreUserServiceDelegate, FirestoreUserInfoDelegate {
    var db: Firestore
    init() {
        db = Firestore.firestore()
    }
    
    //checks if users exists, lets delegater know
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
    //creates user in firestore
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
    //not needed
    func addMessageToFirestore(newMessage: Message){        //let diffInDays = Calendar.current.dateComponents([.day], from: Date(), to: Date())

        //db.collection("Users").document(currUserID!).collection("Videos").addDocument(data: <#T##[String : Any]#>, completion: <#T##((Error?) -> Void)?##((Error?) -> Void)?##(Error?) -> Void#>)
    }
    //load current user's bitmoji for later use
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
    
    
    
}
//to communicate to VC without exposing whole interface

protocol FirestoreUserServiceDelegate {
    func userExists(delegate:SignUpViewControllerFirestoreDelegate, UserID:String)
    func loadCurrUserBitmojiURL()
}
//to communicate to VC without exposing whole interface

protocol FirestoreUserInfoDelegate {
    func createUser(name: String, bitmojiURL:String, VC: UserInfoViewControllerFirestoreDelegate)
}
