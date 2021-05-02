//
//  File.swift
//  AnimojiStudio
//
//  Created by Snehal Mulchandani on 5/1/21.
//  Copyright © 2021 Guilherme Rambo. All rights reserved.
//

import Foundation
import UIKit
//from https://stackoverflow.com/questions/29209453/how-to-hide-a-navigation-bar-from-first-viewcontroller-in-swift
extension UIViewController {
    func hideNavigationBar(animated: Bool){
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)

    }

    func showNavigationBar(animated: Bool) {
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

}
