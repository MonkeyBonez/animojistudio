//
//  Message.swift
//  AnimojiStudio
//
//  Created by Snehal Mulchandani on 5/3/21.
//  Copyright © 2021 Guilherme Rambo. All rights reserved.
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
    //profile pic/bitmoji?
    
    init(videoUrl: URL, location:CLLocation, timeCreated: Timestamp, creatorName: String){
        self.videoUrl = videoUrl
        self.longitude = location.coordinate.longitude
        self.latitude = location.coordinate.latitude
        self.timeCreated = timeCreated
        //self.creatorID = creatorID
        self.creatorName = creatorName
    }
    
    func isExpired()->Bool{
        //https://stackoverflow.com/questions/40075850/swift-3-find-number-of-calendar-days-between-two-dates
        let diffInDays = Calendar.current.dateComponents([.day], from: Date(), to: timeCreated.dateValue()).day ?? 1
        if(diffInDays >= 1){
            return true
        }
        return false
    }
    
    mutating func setCreatorName(creatorName: String){
        self.creatorName = creatorName
    }
    
    static func == (lhs: Message, rhs: Message)->Bool{
        return lhs.videoUrl == rhs.videoUrl
    }
    
    
}
