//
//  FirestoreMessageRecieverService.swift
//  AnimojiStudio
//
//  Created by Snehal Mulchandani on 5/4/21.
//  Copyright © 2021 Guilherme Rambo. All rights reserved.
//

import Foundation
import Firebase
import CodableFirebase
import MapKit


class FirestoreMessageRecieverService: FirestoreMessagesMapService{
    var db:Firestore
    //var messageList: [Message] = []
    
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
                    let newAnnotation = MessageMapAnnotation(message: currMessage)
                    VC.addMapAnnotation(annotation: newAnnotation)
                    
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

protocol FirestoreMessagesMapService {
    func setMessageAnnotations(VC: MapViewControllerFirestoreMessagesDelegate)
}
