//
//  MessageViewController.swift
//  AnimojiStudio
//
//  Created by Snehal Mulchandani on 5/4/21.
//  Snehal Mulchandani - Snehalmu@usc.edu
//

import UIKit
import SceneKit
import ARKit
import CoreMotion
//Augmented-Reality + Core motion used  in this VC to display message to user.
class MessageViewController: ShowsErrorViewController, ARSCNViewDelegate, takesMessageURL {

    @IBOutlet weak var sceneView: ARSCNView!
    var firebaseURL:URL!
    var messageShowed = false
    @IBOutlet weak var arrowDirections: UIImageView!
    //set scene view delegate as self and enable lighting option
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        //ceneView.showsStatistics = true
        
        //sceneView.debugOptions = [.showFeaturePoints]
        
        sceneView.autoenablesDefaultLighting = true
        
    }
    //set up sceneView + Tracking
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        arrowDirections.image = UIImage()
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        // Run the view's session
        sceneView.session.run(configuration)
    }
    //stop the scene view and hide navigation bar as previous view doesn't need it
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
        self.hideNavigationBar(animated: animated)
        //NotificationCenter.default.removeObserver(self)
        //UIDevice.current.endGeneratingDeviceOrientationNotifications()
    }
    
    var motionManager: CMMotionManager!//Sorry this isn't declared at the top I threw the Core motion stuff together pretty last second dont wanna mess it up
    //when view appears, set navigation bar to how we want and start guiding the user to the message
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.showNavigationBar(animated: animated)
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
        motionManager = CMMotionManager()
        self.arrowDirections.isHidden = false
        guideUserToMessage()


    }
    //set up motion manager and get results and respond to show user the correct way to look and display message when they're looking at the correct spot
    func guideUserToMessage(){
        if motionManager.isMagnetometerAvailable {
            //motionManager.magnetometerUpdateInterval = 10.0/60.0
            motionManager.deviceMotionUpdateInterval = 10.0/60.0
            motionManager.magnetometerUpdateInterval = 5.0/60.0
            motionManager.gyroUpdateInterval = 5.0/60.0
            motionManager.accelerometerUpdateInterval = 5.0/60.0
            motionManager.startDeviceMotionUpdates(using: .xTrueNorthZVertical, to: .main) { (deviceMotion, error) in
                if let error = error{
                    //just show memoji
                }
                else{
                    //print(deviceMotion?.magneticField.field.z)
                    if((deviceMotion?.magneticField.field.z)! < -16){
                        self.arrowDirections.image = UIImage(systemName: "arrow.up.square")
                    }
                    else if ((deviceMotion?.magneticField.field.z)! > 8){
                        self.arrowDirections.image = UIImage(systemName: "arrow.down.square")
                    }
                    else{
                        self.motionManager.stopDeviceMotionUpdates()
                        self.motionManager.stopGyroUpdates()
                        self.motionManager.stopMagnetometerUpdates()
                        self.motionManager.stopAccelerometerUpdates()
                        self.arrowDirections.isHidden = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                            self.ShowMemojiMessage()
                        }
                    }
                }
            }
        }
    }
    
    //NOT USED ANYMORE COREMOTION WAY BETTER FOR WHAT I NEED
    @objc func orientationChanged(_ notification: NSNotification){
        let currentOrientation = UIDevice.current.orientation
        if(currentOrientation == .faceUp){
            showError(error: "Move your camera up to see the message!")
            //inform user to move camera up
        }
        else if !messageShowed{
            messageShowed = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                self.ShowMemojiMessage()
            }
        }
        
    }
    //helper function to make video background invisible
    func RGBtoHSV(r : Float, g : Float, b : Float) -> (h : Float, s : Float, v : Float) {
        var h : CGFloat = 0
        var s : CGFloat = 0
        var v : CGFloat = 0
        let col = UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: 1.0)
        col.getHue(&h, saturation: &s, brightness: &v, alpha: nil)
        return (Float(h), Float(s), Float(v))
    }
//CIFILTER to make video invisible in AR view (gotten from stackoverflow: https://stackoverflow.com/questions/50139146/arkit-spritekit-set-pixelbufferattributes-to-skvideonode-or-make-transparent) does this go in model?
    func colorCubeFilterForChromaKey(hueAngle: Float) -> CIFilter {

        let hueRange: Float = 0.1 // degrees size pie shape that we want to replace - Originally 20m
        let minHueAngle: Float = (hueAngle - hueRange/2.0) / 360
        let maxHueAngle: Float = (hueAngle + hueRange/2.0) / 360

        let size = 64
        var cubeData = [Float](repeating: 0, count: size * size * size * 4)
        var rgb: [Float] = [0, 0, 0]
        var hsv: (h : Float, s : Float, v : Float)
        var offset = 0

        for z in 0 ..< size {
            rgb[2] = Float(z) / Float(size) // blue value
            for y in 0 ..< size {
                rgb[1] = Float(y) / Float(size) // green value
                for x in 0 ..< size {

                    rgb[0] = Float(x) / Float(size) // red value
                    hsv = RGBtoHSV(r: rgb[0], g: rgb[1], b: rgb[2])
                    // TODO: Check if hsv.s > 0.5 is really nesseccary
                    let alpha: Float = (hsv.h > minHueAngle && hsv.h < maxHueAngle && hsv.s > 0.5) ? 0 : 1.0

                    cubeData[offset] = rgb[0] * alpha
                    cubeData[offset + 1] = rgb[1] * alpha
                    cubeData[offset + 2] = rgb[2] * alpha
                    cubeData[offset + 3] = alpha
                    offset += 4
                }
            }
        }
        let b = cubeData.withUnsafeBufferPointer { Data(buffer: $0) }
        let data = b as NSData

        let colorCube = CIFilter(name: "CIColorCube", parameters: [
            "inputCubeDimension": size,
            "inputCubeData": data
            ])
        return colorCube!
    }

    
    /*@objc func tapped(recognizer :UIGestureRecognizer) {
        //DEMOShowMemoji()
        ShowMemojiMessage()
      }*/
    
    /*func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        guard let urlString = Bundle.main.path(forResource: "resourceName", ofType: "mp4") else { return nil }
        

        let url = URL(fileURLWithPath: urlString)
        let asset = AVAsset(url: url)
        let item = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: item)

        let videoNode = SKVideoNode(avPlayer: player)
        videoNode.size = CGSize(width: 200.0, height: 150.0)
        videoNode.anchorPoint = CGPoint(x: 0.5, y: 0.0)

        return videoNode
    }*/

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    
    //load Memoji message correctly in AR from video URL and display
    func ShowMemojiMessage(){

        guard let currentFrame = self.sceneView.session.currentFrame else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                self.ShowMemojiMessage()
            }
            return
        }
        //let firebaseURL = URL(string: "https:firebasestorage.googleapis.com/v0/b/sonder-370f3.appspot.com/o/Videos%2FFFPdLgvc9GOLxEssvpn6kRcBJOr21620095230.42256.mp4?alt=media&token=1dd17990-164f-45ab-8823-df867451530d")
        //let videoNode = SKVideoNode(fileNamed: "Recording.mov")
        let videoNode = SKVideoNode(url: firebaseURL!)
      
      videoNode.size = CGSize(width: 200, height: 200)
        videoNode.play()
      videoNode.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        
      
      let effectNode = SKEffectNode()
      effectNode.addChild(videoNode)
      if let a:SKVideoNode? = (effectNode.children[0]) as! SKVideoNode{
          a!.play()
      }
      
  effectNode.filter = colorCubeFilterForChromaKey(hueAngle: 0)
      
      let skScene = SKScene(size: CGSize(width: 640, height: 480))
      skScene.backgroundColor = .clear
      skScene.addChild(effectNode)
        
        effectNode.position = CGPoint(x: skScene.size.width/2, y: skScene.size.height/2)
        
        //effectNode.size = skScene.size
        
        let tvPlane = SCNPlane(width: 1.0, height: 0.75)
      let material = SCNMaterial()
      material.diffuse.contents = UIColor.clear
      view.isOpaque = false
      //material.diffuse.contents = view
      //tvPlane.materials = [material]
      tvPlane.firstMaterial?.diffuse.contents = UIColor.blue
       //ßtvPlane.firstMaterial?.diffuse.contents = skScene
      tvPlane.firstMaterial?.diffuse.contents = skScene
      //tvPlane.insertMaterial(material, at: 0)
       tvPlane.firstMaterial?.isDoubleSided = true
      
      
      
      //self.sceneView.scene.rootNode.addChildNode(effectNode)
//
        let tvPlaneNode = SCNNode(geometry: tvPlane)

        var translation = matrix_identity_float4x4
        translation.columns.3.z = -1.0

        tvPlaneNode.simdTransform = matrix_multiply(currentFrame.camera.transform, translation)
        tvPlaneNode.eulerAngles = SCNVector3(Double.pi,0,0)
        tvPlaneNode.eulerAngles.y = currentFrame.camera.eulerAngles.y
        
        self.sceneView.scene.rootNode.addChildNode(tvPlaneNode)
        
    }
    
}
//protocol to get the URL without exposing whole interface
protocol takesMessageURL {
    var firebaseURL:URL! { get set }
}
