//
//  WelcomeViewController.swift
//  AnimojiStudio
//
//  Created by Snehal Mulchandani on 4/21/21.
//  Copyright © 2021 Guilherme Rambo. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    private let signUpViewControllerStoryboardIdentifier = "signUpVC"


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logInButtonPressed(_ sender: Any) {
    }
    
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let home = storyBoard.instantiateViewController(withIdentifier: signUpViewControllerStoryboardIdentifier) 
        navigationController?.pushViewController(home, animated: true);
    }
    
}
