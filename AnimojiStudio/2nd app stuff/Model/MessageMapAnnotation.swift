//
//  MessageMapAnnotation.swift
//  AnimojiStudio
//
//  Created by Snehal Mulchandani on 5/4/21.
//  Copyright © 2021 Guilherme Rambo. All rights reserved.
//

import Foundation
import MapKit
//https://www.hackingwithswift.com/read/16/2/up-and-running-with-mapkit
class MessageMapAnnotation: NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var videoURL: URL
    var title:String?
    var creatorBitmojiURL: URL
    init(message: Message) {
        self.coordinate = CLLocationCoordinate2D(latitude: message.latitude, longitude: message.longitude)
        self.title = message.creatorName + "'s message"
        self.videoURL = message.videoUrl
        self.creatorBitmojiURL = message.creatorBitmojiURL
        super.init()
    }
    
}
