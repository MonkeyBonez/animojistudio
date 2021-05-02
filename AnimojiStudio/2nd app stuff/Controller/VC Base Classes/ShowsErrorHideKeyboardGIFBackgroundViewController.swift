//
//  ShowsErrorHideKeyboardGIFBackgroundViewController.swift
//  AnimojiStudio
//
//  Created by Snehal Mulchandani on 5/2/21.
//

import Foundation

class ShowsErrorHideKeyboardGIFBackgroundViewController: HideKeyboardOnScreenTapandGIFBackgroundViewController{
    
    func showError(error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let continueAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(continueAction)
        self.present(alert, animated: false)
    }
}


