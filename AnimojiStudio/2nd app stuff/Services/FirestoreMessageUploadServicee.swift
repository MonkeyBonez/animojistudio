//
//  UploadingVideoViewController.swift
//  AnimojiStudio
//
//  Created by Snehal Mulchandani on 5/3/21.
//  Copyright © 2021 Guilherme Rambo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import CoreLocation
import CodableFirebase


@objc class FirestoreMessageUploadService: NSObject, CLLocationManagerDelegate{
    
    @objc static let shared = FirestoreMessageUploadService()
    @objc public var videoURL: NSURL = NSURL()
    var locationManager:CLLocationManager
    var db: Firestore
    override private init() {
        locationManager = CLLocationManager()
        db = Firestore.firestore()
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    deinit {//for debugging - Switched to singleton as gets deinit before location request and thus create video suceeds.
        print("DEINIT")
    }
    
    @objc func uploadVideo(){
        //db.collection("Users").document(currUserID!).collection("Videos").addDocument(data: <#T##[String : Any]#>, completion: <#T##((Error?) -> Void)?##((Error?) -> Void)?##(Error?) -> Void#>)
        let storageRef = StorageReference()
        let videoName = currUser.shared.currUsedID! + String(Date().timeIntervalSince1970)
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
                self.createMessage(url: url)
            }
        }
    }
    
    var newMessageURL:URL?
    func createMessage(url: URL){
        newMessageURL = url
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //change to best
        locationManager.requestLocation()
        //newMessage = Message(videoUrl: url, location: )
        //db.collection("Users").document(currUserID!).collection("Videos").addDocument(data: <#T##[String : Any]#>, completion: <#T##((Error?) -> Void)?##((Error?) -> Void)?##(Error?) -> Void#>)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        db.collection("Users").document(currUser.shared.currUsedID!).getDocument { (document, error) in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            else{
                let name: String = document?.get("name") as! String
                let newMessage = Message(videoUrl: self.newMessageURL!, location: locations.first!, timeCreated: Timestamp(date: Date()), creatorName: name, creatorBitmojiURL: currUser.shared.bitmojiURL!)
                self.uploadMessageToFirestore(newMessage: newMessage)
            }
        }

        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func uploadMessageToFirestore(newMessage: Message){
        //https://github.com/alickbass/CodableFirebase
        let docData = try! FirestoreEncoder().encode(newMessage)
        db.collection("Users").document(currUser.shared.currUsedID!).collection("Videos").addDocument(data: docData, completion: { (error) in
            if let error = error{
                print("Error occured: \(error.localizedDescription)")
            }
            else{
                //succesful, go back to map?
            }
        })
        
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
