//
//  UITabBarTransparentExtension.swift
//  AnimojiStudio
//
//  Created by Snehal Mulchandani on 5/3/21.
//  Snehal Mulchandani - Snehalmu@usc.edu
//
//https://dev-georgegarcia.medium.com/creating-a-fully-transparent-uitabbar-in-swift-ae689f3e4c51
import Foundation
import UIKit
//extension to set the tab bar to transparent, easily
extension UITabBar{
    static func setTransparentTabBar(){
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().clipsToBounds = true
    }
}
