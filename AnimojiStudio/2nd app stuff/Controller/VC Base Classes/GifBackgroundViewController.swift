//
//  GifBackgroundProtocol.swift
//  AnimojiStudio
//
//  Created by Snehal Mulchandani on 4/22/21.
//
import Foundation
class GifBackgroundViewController: UIViewController{//Used for any background needing to load GIF
    @IBOutlet weak var backgroundImage: UIImageView! = nil//Image View to be updated
    var backgroundImageName: String = ""//Currently filename of gif in main bundle Change to URL/[URL] Later?
    func loadBackground(){
        do{
            //https://stackoverflow.com/questions/27919620/how-to-load-gif-image-in-swift switch to URL w/ Firebase
            let data = try Data(contentsOf: Bundle.main.url(forResource: backgroundImageName, withExtension: "gif")!)//load gif file into data
            let gif = UIImage.gifImageWithData(data)//make data of type gif from UIImage
            backgroundImage.image = gif//set the ImageView's image to the gif
        }
        catch{
            return
        }
    }
}
