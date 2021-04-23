//
//  WelcomeViewController.swift
//  AnimojiStudio
//
//  Created by Snehal Mulchandani on 4/21/21.
//

import UIKit
import ImageIO
//inherit from GIF 
class WelcomeViewController: GifBackgroundViewController {
    private let signUpViewControllerStoryboardIdentifier = "signUpVC"

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundImageName = "Background"
        loadBackground()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logInButtonPressed(_ sender: Any) {
    }
    
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: .main)
        let home = storyBoard.instantiateViewController(withIdentifier: signUpViewControllerStoryboardIdentifier) 
        navigationController?.pushViewController(home, animated: true);
    }
    
}

