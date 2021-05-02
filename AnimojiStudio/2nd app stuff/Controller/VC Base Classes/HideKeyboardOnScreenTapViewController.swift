//
//  HideKeyboardOnScreenTapVC.swift
//  AnimojiStudio
//
//  Created by Snehal Mulchandani on 5/2/21.
//

import Foundation

class HideKeyboardOnScreenTapandGIFBackgroundViewController: GifBackgroundViewController{
    var keyboardsToHide: [UITextField] = []
    
    @objc func hideKeyboards(){
        for keyboard in keyboardsToHide{
            keyboard.resignFirstResponder()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpScreenTapRemoveKeyboards()
    }
    
    func setUpScreenTapRemoveKeyboards(){
        let screenTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboards))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(screenTap)
    }
}
