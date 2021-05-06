//
//  FirestoreMessageRecieverService.swift
//  AnimojiStudio
//
//  Created by Snehal Mulchandani on 5/4/21.
//  Snehal Mulchandani - Snehalmu@usc.edu
//

import Foundation
import Firebase
import CodableFirebase
import MapKit

//Firestore service to download messges
class FirestoreMessageRecieverService: FirestoreMessagesMapService{
    var db:Firestore
    //var messageList: [Message] = []
    // create map annottations of user when message made
    func setMessageAnnotations(ofUser ID: String, VC: MapViewControllerFirestoreMessagesDelegate){
        db.collection("Users").document(ID).collection("Videos").addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                    print("Error fetching documents: \(error!)")
                    return
            }
            snapshot.documentChanges.forEach{diff in
                let currMessage = try! FirestoreDecoder().decode(Message.self, from: diff.document.data())
                if diff.type == .added{
                    //add new annotation
                    if(!currMessage.isExpired()){
                        let newAnnotation = MessageMapAnnotation(message: currMessage)
                        VC.addMapAnnotation(annotation: newAnnotation)
                    }
                    
                }
                else if diff.type == .modified{
                    //TODO later
                    //remove annotation and add
                }
                else if diff.type == .removed{
                    //TODO later
                    //remove annotation
                }
            }
        }
    }
    //start making map annotations for self and friends
    func setMessageAnnotations(VC: MapViewControllerFirestoreMessagesDelegate){
        self.setMessageAnnotations(ofUser: currUser.shared.currUsedID!, VC: VC)
        db.collection("Users").document(currUser.shared.currUsedID!).collection("Friends").addSnapshotListener { (friendsSnapshot, friendsError) in
            if let friendsError = friendsError{
                print (friendsError.localizedDescription)
            }
            else{
                friendsSnapshot?.documentChanges.forEach({ (friendsDocumentChange) in
                    let currFriend = try! FirestoreDecoder().decode(User.self, from: friendsDocumentChange.document.data())
                    if friendsDocumentChange.type == .added{
                        self.setMessageAnnotations(ofUser: currFriend.userID ?? friendsDocumentChange.document.documentID, VC: VC)
                    }
                    else if friendsDocumentChange.type == .removed{
                        //remove annotations - TODO
                    }
                })
            }
        }
    }

    
    init(){
        db = Firestore.firestore()
    }
    
}
//to communicate to VC without exposing whole interface

protocol FirestoreMessagesMapService {
    func setMessageAnnotations(VC: MapViewControllerFirestoreMessagesDelegate)
}
