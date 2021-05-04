//
//  UploadingVideoViewController.swift
//  AnimojiStudio
//
//  Created by Snehal Mulchandani on 5/3/21.
//  Copyright © 2021 Guilherme Rambo. All rights reserved.
//

import UIKit
import Firebase

@objc class FirestoreVideoUploadService: NSObject {

    @objc public var videoURL: NSURL = NSURL()
    
    override init() {
        super.init()
    }
    
    @objc func uploadVideo(){
        //db.collection("Users").document(currUserID!).collection("Videos").addDocument(data: <#T##[String : Any]#>, completion: <#T##((Error?) -> Void)?##((Error?) -> Void)?##(Error?) -> Void#>)
        let storageRef = StorageReference()
        let videoName = currUserID! + String(Date().timeIntervalSince1970)
        let videoRef = storageRef.child("Videos/\(videoName).mp4")
        let videoFile:URL = videoURL.absoluteURL!
        
        let uploadTask = videoRef.putFile(from: videoFile, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else{
                print("Couldn't upload " + error!.localizedDescription)
                return
            }
            videoRef.downloadURL { (url, error) in
                guard let url = url else{
                    print("Eror: " + error!.localizedDescription)
                    return
                }
                //print(url)
                self.createVideo(url: url)
            }
        }
    }
    func createVideo(url: URL){
        
    }
    /*override func viewDidLoad() {
        super.viewDidLoad()
        print(videoURL)
        // Do any additional setup after loading the view.
    }*/
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
