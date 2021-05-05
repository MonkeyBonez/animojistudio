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
    
    func setMessageAnnotations(VC: MapViewControllerFirestoreMessagesDelegate){
        var friendsIDs = [currUser.shared.currUsedID!] //change to get friends - snapshot listener
        for ID in friendsIDs{
            db.collection("Users").document(ID).collection("Videos").addSnapshotListener { [self] (querySnapshot, error) in
                guard let snapshot = querySnapshot else {
                        print("Error fetching documents: \(error!)")
                        return
                }
                /*let documents  = snapshot.documents
                for document in documents{
                    let newMessage = try! FirestoreDecoder().decode(Message.self, from: document.data())
                    if (!self.messageList.contains(newMessage) && !newMessage.isExpired()){
                        self.messageList.append(newMessage)
                        let newAnnotation = MessageMapAnnotation(message: newMessage)
                        VC.addMapAnnotation(annotation: newAnnotation)
                        
                    }
                }*/
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
        
    }
    
    init(){
        db = Firestore.firestore()
    }
    /*func getMessages(VC: MapViewControllerFirestoreMessagesDelegate){
        VC.clearMessages()
        var friendsIDs = [currUser.shared.currUsedID!] //change to get friends @Published?
        for ID in friendsIDs{
            db.collection("Users").document(ID).collection("Videos").getDocuments { (querySnapshot, error) in
                if let error = error{
                    VC.showError(error: error.localizedDescription)
                    return
                }else{
                    var newMessages: [Message] = []
                    for document in querySnapshot!.documents{
                        var message = try! FirestoreDecoder().decode(Message.self, from: document.data())
                        //fix: message.setCreatorName(creatorName: <#T##String#>)
                        newMessages.append(message)
                    }
                    VC.setMessages(newMessages: newMessages)
                }
                
            }
        }
    }*/
}

protocol FirestoreMessagesMapService {
    func setMessageAnnotations(VC: MapViewControllerFirestoreMessagesDelegate)
}
