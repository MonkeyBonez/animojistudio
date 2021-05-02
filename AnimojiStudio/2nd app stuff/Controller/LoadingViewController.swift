//
//  LoadingViewController.swift
//  AnimojiStudio
//
//  Created by Snehal Mulchandani on 5/2/21.
//  Copyright © 2021 Guilherme Rambo. All rights reserved.
//

import UIKit

class LoadingViewController: GifBackgroundViewController {

    @IBOutlet weak var BackgroundImageView: UIImageView!
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
