//
//  MessageMapAnnotation.swift
//  AnimojiStudio
//
//  Created by Snehal Mulchandani on 5/4/21.
//  Snehal Mulchandani - Snehalmu@usc.edu
//

import Foundation
import MapKit

//https://www.hackingwithswift.com/read/16/2/up-and-running-with-mapkit
class MessageMapAnnotation: NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var videoURL: URL
    var title:String?
    var creatorBitmojiURL: URL
    var currOpacity: Double
    init(message: Message) {
        self.coordinate = CLLocationCoordinate2D(latitude: message.latitude, longitude: message.longitude)
        self.title = message.creatorName + "'s message"
        self.videoURL = message.videoUrl
        self.creatorBitmojiURL = message.creatorBitmojiURL
        self.currOpacity = message.getOpacity()
        super.init()
    }
    
}
