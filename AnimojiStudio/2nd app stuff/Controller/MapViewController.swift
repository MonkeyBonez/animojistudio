//
//  MapViewController.swift
//  AnimojiStudio
//  Snehal Mulchandani - Snehalmu@usc.edu

//  Created by Snehal Mulchandani on 4/22/21.
//

import UIKit
import MapKit
//class with map to display user messagse
class MapViewController: ShowsErrorViewController, MKMapViewDelegate, MapViewControllerFirestoreMessagesDelegate {
    
    private let mapTileURL = "http://tile.stamen.com/watercolor/{z}/{x}/{y}.jpg"
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var magnifyingGlassButton: UIButton!
    private let locationManager = CLLocationManager()
    private let metersRadiusToShow: CLLocationDistance = 2200
    private let tileMinZoom: CLLocationDistance = 8500
    private var zoomed = false
    private let smallRadiusToDisplay: CLLocationDistance = 50//increase
    
    private var overlay: MKTileOverlay = MKTileOverlay()
    var messageService:FirestoreMessagesMapService!
    var FirestoreUserServicesDelegate: FirestoreUserServiceDelegate!
    
    var messages: [Message] = []
    //set up delegates
    override func viewDidLoad() {
        super.viewDidLoad()
        overlay = MKTileOverlay(urlTemplate: mapTileURL)
        getUserLocationAccess()
        setUpMap()
        tileZoomOnUser(animated: false)
        messageService = FirestoreMessageRecieverService()
        messageService.setMessageAnnotations(VC: self)
        FirestoreUserServicesDelegate = FirestoreUserService()
        FirestoreUserServicesDelegate.loadCurrUserBitmojiURL()
        //update user bitmoji URL
        
    }
    
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //deselectAnnotations()
    }
    //set up map to be in the nice map tile view at first
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadMapFromTiles()
        tileZoomOnUser(animated: false)
        magnifyingGlassButton.setImage(UIImage(systemName: "plus.magnifyingglass"), for: .normal)
        zoomed = false
    }
    //https://stackoverflow.com/questions/40492623/mkmapview-does-call-didselect-callback-only-once
    func deselectAnnotations(){
        DispatchQueue.main.async {
            for annotation in self.mapView.selectedAnnotations{
                self.mapView.deselectAnnotation(annotation, animated: false)
            }
        }
    }
    
    //zoom on user how I want when tile map is loaded
    func tileZoomOnUser(animated: Bool){
        guard let currLocation = mapView.userLocation.location else {
            return
        }
        //var LACoordinate = CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437)
        let regionToShow = MKCoordinateRegion(center: currLocation.coordinate, latitudinalMeters: metersRadiusToShow, longitudinalMeters: metersRadiusToShow)
        mapView.setRegion(regionToShow, animated: animated)
        
    }
    //zoom on user how I want when regular Apple maps is loaded
    func regularZoomOnUser(){
        guard let currLocation = mapView.userLocation.location else {
            return
        }
        let regionToShow = MKCoordinateRegion(center: currLocation.coordinate, latitudinalMeters: smallRadiusToDisplay, longitudinalMeters: smallRadiusToDisplay)
        mapView.setRegion(regionToShow, animated: true)
    }
    //initilize map with self s delegate and load from map tiles
    func setUpMap(){
        mapView.delegate = self
        mapView.showsUserLocation = true
        loadMapFromTiles()
        //set Max Zoom if needed
    }
    // loads map from tilse
    func loadMapFromTiles(){
        mapView.setCameraZoomRange(MKMapView.CameraZoomRange(minCenterCoordinateDistance: tileMinZoom), animated: false)
        overlay.canReplaceMapContent = true
        mapView.addOverlay(overlay, level: .aboveRoads)//change lab els to .aboveLabels to remove labels (puts map custom labels)
    }
    //loads map from reegular apple maps
    func loadRegularMap(){
        mapView.setCameraZoomRange(MKMapView.CameraZoomRange(maxCenterCoordinateDistance: tileMinZoom), animated: false)
        mapView.removeOverlay(overlay)
    }
    //get user lcoation
    func getUserLocationAccess(){
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
    }
    //needed to render from tiles
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKTileOverlay{
            let renderer = MKTileOverlayRenderer(overlay: overlay)
            return renderer
        }
        else{
            return MKOverlayRenderer()
        }
        
    }
    //how to zoom when button pressed
    @IBAction func magnifyingGlassButtonPressed(_ sender: Any) {
        if(!zoomed){//fix to not have to !
            loadRegularMap()
            regularZoomOnUser()
            magnifyingGlassButton.setImage(UIImage(systemName: "minus.magnifyingglass"), for: .normal)
        }
        else{
            loadMapFromTiles()
            tileZoomOnUser(animated: true)//true?
            magnifyingGlassButton.setImage(UIImage(systemName: "plus.magnifyingglass"), for: .normal)
        }
        zoomed.toggle()
    }
    
    /*func clearMessages(){
        messages = []
    }
    
    //function not needed
    /*func addMessage(newMessage: Message){
        messages.append(newMessage)
    }*/
    
    func setMessages(newMessages: [Message]){
        messages = newMessages
    }*/
    //for delegate to add annotations
    func addMapAnnotation(annotation: MessageMapAnnotation){
        mapView.addAnnotation(annotation)
    }
    
    //https://www.hackingwithswift.com/example-code/location/how-to-add-annotations-to-mkmapview-using-mkpointannotation-and-mkpinannotationview
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: MKUserLocation.self){
            //https://www.raywenderlich.com/9697133-advanced-mapkit-tutorial-custom-mapkit-tiles
            if let existingView = mapView
              .dequeueReusableAnnotationView(withIdentifier: "user") {
              return existingView
            }
            else{
                let view = MKAnnotationView(annotation: annotation, reuseIdentifier: "user")
                view.image = UIImage(named: "stickFigure.png", in: .main, with: nil)
                view.frame = CGRect(x: 0, y: 0, width: 55, height: 75)
                if #available(iOS 14.0, *) {
                    view.zPriority = .max
                } else {
                    // Fallback on earlier versions
                    //annotationView?.bringSubviewToFront(<#T##view: UIView##UIView#>)
                }
                return view
            }
        }
        guard annotation is MessageMapAnnotation else {
            return nil
        }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil{
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            //annotationView?.canShowCallout = true
            //annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else{
            annotationView!.annotation = annotation
        }
        
        let customMapAnnotation = annotation as! MessageMapAnnotation
        do {
            //let pinImage = try UIImage(data: NSData(contentsOf: customMapAnnotation.creatorBitmojiURL) as Data)
            
           try annotationView?.image = UIImage(data: NSData(contentsOf: customMapAnnotation.creatorBitmojiURL) as Data)
            //annotationView?.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: pinImage!.size)
            //annotationView?.centerOffset = CGPoint(x: 0, y: -(pinImage?.size.height)!/2)

        } catch {
            print("Error with loading user image")
        }
        
        annotationView?.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        annotationView?.alpha = CGFloat(customMapAnnotation.currOpacity)
        return annotationView
    }
    
    //https://stackoverflow.com/questions/49370104/disable-mylocation-marker-tap-in-mapkit-swift
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        let userView = mapView.view(for: mapView.userLocation)
        userView?.isUserInteractionEnabled = false
                userView?.isEnabled = false
                userView?.canShowCallout = false
    }
    //how to react to annottion presses: go to message view
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation is MKUserLocation{
            return
        }
        guard let messageAnnotation = view.annotation as? MessageMapAnnotation else {
            return
        }

        if((mapView.userLocation.location?.distance(from: CLLocation(latitude: view.annotation!.coordinate.latitude, longitude: view.annotation!.coordinate.longitude)))! < 40){
            var vc:takesMessageURL = UIStoryboard.init(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "MessageViewerVC") as! MessageViewController
            vc.firebaseURL = messageAnnotation.videoURL
            self.navigationController?.pushViewController(vc as! UIViewController, animated: false)
        }
        else{
            showError(error: "Get closer to message")//handle better
        }
            
        
        deselectAnnotations()
    }
    

}
//protocol to expose necesary interface to delegate
protocol  MapViewControllerFirestoreMessagesDelegate: CanShowErrorProtocol{
    var messages: [Message]{ get set }
    //func clearMessages()
    //func addMessage(newMessage: Message)
    //func setMessages(newMessages: [Message])
    func addMapAnnotation(annotation: MessageMapAnnotation)
    
}
