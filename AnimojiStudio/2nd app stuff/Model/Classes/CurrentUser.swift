//
//  CurrentUser.swift
//  AnimojiStudio
//
//  Created by Snehal Mulchandani on 5/4/21.
//  Snehal Mulchandani - Snehalmu@usc.edu
//
import Firebase

import Foundation
class currUser {
    private init(){}
    static let shared = currUser()
    @Published var currUsedID: String? = Firebase.Auth.auth().currentUser?.uid
    var bitmojiURL: URL?
}
