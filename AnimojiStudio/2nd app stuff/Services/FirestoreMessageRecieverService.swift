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
    var messageList: [Message] = []
    
    func setMessageAnnotations(VC: MapViewControllerFirestoreMessagesDelegate){
        var friendsIDs = [currUser.shared.currUsedID!] //change to get friends - snapshot listener
        for ID in friendsIDs{
            db.collection("Users").document(ID).collection("Videos").addSnapshotListener { [self] (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                        print("Error fetching documents: \(error!)")
                        return
                }
                for document in documents{
                    let newMessage = try! FirestoreDecoder().decode(Message.self, from: document.data())
                    if (!self.messageList.contains(newMessage)){
                        self.messageList.append(newMessage)
                        let newAnnotation = MKPointAnnotation()
                        newAnnotation.title = newMessage.creatorName
                        newAnnotation.coordinate = CLLocationCoordinate2D(latitude: newMessage.latitude, longitude: newMessage.longitude)
                        VC.addMapAnnotation(annotation: newAnnotation)
                        
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
