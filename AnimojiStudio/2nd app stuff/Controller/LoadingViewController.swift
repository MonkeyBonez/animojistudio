//
//  LoadingViewController.swift
//  AnimojiStudio
//
//  Created by Snehal Mulchandani on 5/2/21.
//  Snehal Mulchandani - Snehalmu@usc.edu
//

import UIKit

class LoadingViewController: GifBackgroundViewController {

    @IBOutlet weak var BackgroundImageView: UIImageView!
    //set background GIF Image
    override func viewDidLoad() {
        self.backgroundImage = BackgroundImageView
        self.backgroundImageName = "Background"
        super.viewDidLoad()
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
