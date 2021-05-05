//
//  FirebaseFriendsService.swift
//  AnimojiStudio
//
//  Created by Snehal Mulchandani on 5/5/21.
//  Copyright © 2021 Guilherme Rambo. All rights reserved.
//

import Foundation
import Firebase
import CodableFirebase
import Contacts

class FirebaseFriendsService: FirestoreAddFriendsDelegate {
    var VC: addFriendsTableView!
    var db: Firestore
    var FirebaseUsers:[User]  = []{
        didSet{
            VC.refreshList()
        }
    }
    
    
    init() {
        db = Firestore.firestore()
    }
    
    func getContactsFromFirestore(alreadyFriends:[User], contacts: [Contact]){
        let friendIDs:[String?] = alreadyFriends.map{$0.userID}
        let telephones: [String] = contacts.map{$0.telephone}
        db.collection("Users").getDocuments { (querySnapshot, error) in
            if let error = error{
                print(error.localizedDescription)
            }
            else{
                for document in querySnapshot!.documents{
                    if !friendIDs.contains(document.documentID){
                        var tempUser = try! FirestoreDecoder().decode(User.self, from: document.data())
                        tempUser.userID = document.documentID
                        if tempUser.telephone != UserDefaults.standard.value(forKey: "Phone Number") as! String{
                            if !(telephones.filter({ (number) -> Bool in
                                tempUser.matchingTelephone(telephoneToMatch: number)
                            })).isEmpty{
                                self.FirebaseUsers.append(tempUser)
                            }
                        }
                    }
                }
                    
            }
        }
    }
    
    func findContacts(contacts: [Contact]){
        //telephones = ["(562)280-6387"] //for testing
        db.collection("Users").document(currUser.shared.currUsedID!).collection("Friends").getDocuments { (friendsSnapshot, friendsError) in
            if let friendsError = friendsError{
                print(friendsError.localizedDescription)
            }
            else{
                var friendsList:[User] = []
                for document in friendsSnapshot!.documents{
                    var tempUser = try! FirestoreDecoder().decode(User.self, from: document.data())
                    friendsList.append(tempUser)
                }
                self.getContactsFromFirestore(alreadyFriends: friendsList, contacts: contacts)
            }
        }
    }
    
    func askForContactAccess(){
        CNContactStore().requestAccess(for: .contacts) { (access, error) in
          print("Access: \(access)")
            if let error = error{
                print(error.localizedDescription)
            }
            else{
                self.loadContacts()
            }
        }
    }
    
    func loadContacts(){
        var contacts:[Contact] = []
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        do{
            try CNContactStore().enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
                                contacts.append(Contact(firstName: contact.givenName, lastName: contact.familyName, telephone: contact.phoneNumbers.first?.value.stringValue ?? ""))
            })
            findContacts(contacts: contacts)
        }
        catch {
            print("Failed to get contact")
        }
    }
    
    func addFriend(position: Int){
        let newFriend = FirebaseUsers[position]
        let docData = try! FirestoreEncoder().encode(newFriend)
        FirebaseUsers.remove(at: position)
        db.collection("Users").document(currUser.shared.currUsedID!).collection("Friends").document(newFriend.userID!).setData(docData)
    }
    
    
}

protocol FirestoreAddFriendsDelegate: class {
    var FirebaseUsers:[User]{get set}
    var VC: addFriendsTableView! { get set }
    func askForContactAccess()
    func addFriend(position: Int)
}
