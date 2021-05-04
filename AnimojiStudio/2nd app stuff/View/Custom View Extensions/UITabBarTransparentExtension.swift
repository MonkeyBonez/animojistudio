//
//  UITabBarTransparentExtension.swift
//  AnimojiStudio
//
//  Created by Snehal Mulchandani on 5/3/21.
//  Copyright © 2021 Guilherme Rambo. All rights reserved.
//
//https://dev-georgegarcia.medium.com/creating-a-fully-transparent-uitabbar-in-swift-ae689f3e4c51
import Foundation
import UIKit

extension UITabBar{
    static func setTransparentTabBar(){
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().clipsToBounds = true
    }
}
