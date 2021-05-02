//
//  UserInfoViewController.swift
//  AnimojiStudio
//
//  Created by Snehal Mulchandani on 5/2/21.

//

import UIKit

class UserInfoViewController: GifBackgroundViewController {
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImageName = "Background2"
        backgroundImage = imageView
        loadBackground()
        // Do any additional setup after loading the view.
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
