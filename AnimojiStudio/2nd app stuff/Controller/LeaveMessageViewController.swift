//
//  LeaveMessageViewController.swift
//  AnimojiStudio
//
//  Created by Snehal Mulchandani on 5/3/21.
//  Copyright © 2021 Guilherme Rambo. All rights reserved.
//

import UIKit

class LeaveMessageViewController: UIViewController {
//https://stackoverflow.com/questions/17499391/ios-nested-view-controllers-view-inside-uiviewcontrollers-view
    override func viewDidLoad() {
        super.viewDidLoad()
        let childViewController = recordingFlowController
        self.addChild(childViewController)
        self.view.addSubview(childViewController.view)
        childViewController.didMove(toParent: self)
        //UIApplication.shared.setStatusBarHidden(<#T##hidden: Bool##Bool#>, with: <#T##UIStatusBarAnimation#>)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        goToMemojiView()
    }
    

    func goToMemojiView(){
        
    }

}
