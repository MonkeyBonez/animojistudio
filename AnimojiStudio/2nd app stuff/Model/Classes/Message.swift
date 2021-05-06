//
//  Message.swift
//  AnimojiStudio
//
//  Created by Snehal Mulchandani on 5/3/21.
//  Snehal Mulchandani - Snehalmu@usc.edu
//

import Foundation
import CoreLocation
import Firebase
struct Message:Codable, Equatable{
    var videoUrl:URL
    var latitude:Double
    var longitude:Double
    var timeCreated:Timestamp
    //var creatorID:String
    var creatorName:String
    var creatorBitmojiURL:URL
    
    init(videoUrl: URL, location:CLLocation, timeCreated: Timestamp, creatorName: String, creatorBitmojiURL: URL){
        self.videoUrl = videoUrl
        self.longitude = location.coordinate.longitude
        self.latitude = location.coordinate.latitude
        self.timeCreated = timeCreated
        //self.creatorID = creatorID
        self.creatorName = creatorName
        self.creatorBitmojiURL = creatorBitmojiURL
    }
    
    func isExpired()->Bool{
        //https://stackoverflow.com/questions/40075850/swift-3-find-number-of-calendar-days-between-two-dates
        let diffInDays = Calendar.current.dateComponents([.day], from: timeCreated.dateValue(), to: Date()).day ?? 1
        print(videoUrl)
        print(diffInDays)
        if(diffInDays >= 1){
            //delete from FB?
            return true
        }
        return false
    }
    
    func getOpacity()->Double{
        let diffInMinutes:Double = Double(Calendar.current.dateComponents([.minute], from:timeCreated.dateValue() , to: Date()).minute!)
        print(diffInMinutes)
        return 1.0-(diffInMinutes/(24.0*60.0))
    }
    
    mutating func setCreatorName(creatorName: String){
        self.creatorName = creatorName
    }
    
    static func == (lhs: Message, rhs: Message)->Bool{
        return lhs.videoUrl == rhs.videoUrl
    }
    
    
}
