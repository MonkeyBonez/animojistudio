//
//  User.swift
//  AnimojiStudio
//
//  Created by Snehal Mulchandani on 5/5/21.
//  Snehal Mulchandani - Snehalmu@usc.edu
//

import Foundation
import CodableFirebase

struct User: Codable {
    var name: String
    var bitmojiURL: String
    var telephone: String
    var userID: String?
    
    
    func matchingTelephone(telephoneToMatch: String) -> Bool{
        var numsToCheck: [String] = []
        var  processedPhoneNumber = telephone
        processedPhoneNumber.insert("-", at: processedPhoneNumber.index(processedPhoneNumber.endIndex, offsetBy: -4))
        var tempPhoneNumber = processedPhoneNumber
        if telephoneToMatch.first == "+"{
            tempPhoneNumber.insert("(", at: telephone.index(tempPhoneNumber.startIndex, offsetBy: 2))
            tempPhoneNumber.insert(")", at: telephone.index(tempPhoneNumber.startIndex, offsetBy: 6))
            numsToCheck.append(tempPhoneNumber)
            tempPhoneNumber = processedPhoneNumber
        }
        else if(telephoneToMatch.first == "("){
            tempPhoneNumber = String(processedPhoneNumber.dropFirst(2))
            tempPhoneNumber.insert("(", at: telephone.index(tempPhoneNumber.startIndex, offsetBy: 0))
            tempPhoneNumber.insert(")", at: telephone.index(tempPhoneNumber.startIndex, offsetBy: 4))
            tempPhoneNumber.insert(" ", at: telephone.index(tempPhoneNumber.startIndex, offsetBy: 5))
            numsToCheck.append(tempPhoneNumber)
            tempPhoneNumber = processedPhoneNumber
            
        }
        else{
            if(telephoneToMatch.count == 10){
                tempPhoneNumber = String(processedPhoneNumber.dropFirst(2))
            }
        }
        /*let phoneNumWithoutPlus = telephone.dropFirst(1)
        numsToCheck.append(String(phoneNumWithoutPlus))
        let phoneNumWithoutPlusOne = telephone.dropFirst(2)
        numsToCheck.append(String(phoneNumWithoutPlusOne))
        if(phoneNumWithoutPlusOne.prefix(3) == UserDefaults.standard.value(forKey: "Phone Number") as! Substring.SubSequence){
            let phoneNumWithoutAreaCode = telephone.dropFirst(5)
            numsToCheck.append(String(phoneNumWithoutAreaCode))
        }*/

        for number in numsToCheck{
            if number == telephoneToMatch{
                return true
            }
        }
        return false
    }
}
