//
//  SignUpViewController.swift
//  AnimojiStudio
//
//  Created by Snehal Mulchandani on 4/21/21.
//

import UIKit

class SignUpViewController: GifBackgroundViewController {


    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundImageName = "Background2"
        self.loadBackground()
    }
    

}
