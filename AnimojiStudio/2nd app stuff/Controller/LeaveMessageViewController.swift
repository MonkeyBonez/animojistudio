//
//  LeaveMessageViewController.swift
//  AnimojiStudio
//
//  Created by Snehal Mulchandani on 5/3/21.
//  Snehal Mulchandani - Snehalmu@usc.edu
//

import UIKit

//VC for handling connecting to objective-c code
class LeaveMessageViewController: UIViewController {
//https://stackoverflow.com/questions/17499391/ios-nested-view-controllers-view-inside-uiviewcontrollers-view
    //when view is loaded show memoji view
    override func viewDidLoad() {
        super.viewDidLoad()
        goToMemojiView()
        //UIApplication.shared.setStatusBarHidden(<#T##hidden: Bool##Bool#>, with: <#T##UIStatusBarAnimation#>)
        
    }
    
    //connects to memoji code to capture and record your message from Obj-C recordingFlowController etc.
    func goToMemojiView(){
        let childViewController = recordingFlowController
        self.addChild(childViewController)
        self.view.addSubview(childViewController.view)
        childViewController.didMove(toParent: self)
    }

}
