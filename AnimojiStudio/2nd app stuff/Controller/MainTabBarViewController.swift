//
//  MainTabBarViewController.swift
//  AnimojiStudio
//
//  Created by Snehal Mulchandani on 5/3/21.
//  Snehal Mulchandani - Snehalmu@usc.edu
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    //sets the tab bar to be transparent
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.setTransparentTabBar()

        // Do any additional setup after loading the view.
    }
    
    //automatically hide navigation bar
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.hideNavigationBar(animated: animated)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
