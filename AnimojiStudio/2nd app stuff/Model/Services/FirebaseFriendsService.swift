//
//  FirebaseFriendsService.swift
//  AnimojiStudio
//
//  Created by Snehal Mulchandani on 5/5/21.
//  Snehal Mulchandani - Snehalmu@usc.edu
//

import Foundation
import Firebase
import CodableFirebase
import Contacts
//service with Firestore for friends
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
    //check contact numbers with fiebasee users numbers
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
    // get contacts and pass to getContactsFromFirestoe once we have a list of friends
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
    //load contacts of user and pass to find contacts
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
    //add a friend in Firestore
    func addFriend(position: Int){
        let newFriend = FirebaseUsers[position]
        let docData = try! FirestoreEncoder().encode(newFriend)
        FirebaseUsers.remove(at: position)
        db.collection("Users").document(currUser.shared.currUsedID!).collection("Friends").document(newFriend.userID!).setData(docData)
    }
    
    
}
//to communicate to VC without exposing whole interface

protocol FirestoreAddFriendsDelegate: class {
    var FirebaseUsers:[User]{get set}
    var VC: addFriendsTableView! { get set }
    func askForContactAccess()
    func addFriend(position: Int)
}
