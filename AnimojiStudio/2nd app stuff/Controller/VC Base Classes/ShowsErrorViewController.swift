//
//  ShowsErrorViewController.swift
//  AnimojiStudio
//
//  Created by Snehal Mulchandani on 5/4/21.
//  Snehal Mulchandani - Snehalmu@usc.edu
//

import UIKit

class ShowsErrorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func showError(error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let continueAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(continueAction)
        self.present(alert, animated: false)
    }

}
