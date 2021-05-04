//
//  Message.swift
//  AnimojiStudio
//
//  Created by Snehal Mulchandani on 5/3/21.
//  Copyright © 2021 Guilherme Rambo. All rights reserved.
//

import Foundation
import CoreLocation
struct Message:Codable{
    var videoUrl:URL
    var latitude:Double
    var longitude:Double
    var timeCreated:Date
    var creatorID:String
    
    init(videoUrl: URL, location:CLLocation, timeCreated: Date, creatorID: String){
        self.videoUrl = videoUrl
        self.longitude = location.coordinate.longitude
        self.latitude = location.coordinate.latitude
        self.timeCreated = timeCreated
        self.creatorID = creatorID
    }
    
    func isExpired()->Bool{
        //https://stackoverflow.com/questions/40075850/swift-3-find-number-of-calendar-days-between-two-dates
        let diffInDays = Calendar.current.dateComponents([.day], from: Date(), to: timeCreated).day ?? 1
        if(diffInDays >= 1){
            return true
        }
        return false
    }
    
    
}
