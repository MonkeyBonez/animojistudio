//
//  UserInfoViewController.swift
//  AnimojiStudio
//
//  Created by Snehal Mulchandani on 5/2/21.

//

import UIKit

class UserInfoViewController: ShowsErrorHideKeyboardGIFBackgroundViewController, UserInfoViewControllerFirestoreDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    var userInfoDelegate:FirestoreUserInfoDelegate!

    
    override func viewDidLoad() {
        backgroundImageName = "Background2"
        backgroundImage = imageView
        self.keyboardsToHide = [nameTextField]
        userInfoDelegate = FirestoreUserService()
        super.viewDidLoad()
        //loadBackground()
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func enterButtonPressed(_ sender: Any) {
        //input preprocessing
        var nameError = false
        let nameWithoutSpace = nameTextField.text?.trimmingCharacters(in: CharacterSet(arrayLiteral: " "))
        if let name = nameWithoutSpace{
            if(name.isEmpty){
                nameError = true
            }
            else{
                userInfoDelegate.createUser(name: name, VC: self)
            }
        }
        
        
        //check all errors and call input error to inform user
        if(nameError){
            inputError(nameError: nameError)
        }
    }
    
    func inputError(nameError: Bool){
        showError(error: "Please enter your name")
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

protocol UserInfoViewControllerFirestoreDelegate: CanShowErrorProtocol {
}
