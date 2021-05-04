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
}
