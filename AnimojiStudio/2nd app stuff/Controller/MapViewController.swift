//
//  MapViewController.swift
//  AnimojiStudio
//
//  Created by Snehal Mulchandani on 4/22/21.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    private let mapTileURL = "http://tile.stamen.com/watercolor/{z}/{x}/{y}.jpg"
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var magnifyingGlassButton: UIButton!
    private let locationManager = CLLocationManager()
    private let metersRadiusToShow: CLLocationDistance = 2200
    private let tileMinZoom: CLLocationDistance = 8500
    private var zoomed = false
    private let smallRadiusToDisplay: CLLocationDistance = 50//increase
    
    private var overlay: MKTileOverlay = MKTileOverlay()
    override func viewDidLoad() {
        super.viewDidLoad()
        overlay = MKTileOverlay(urlTemplate: mapTileURL)
        getUserLocationAccess()
        setUpMap()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tileZoomOnUser(animated: false)
    }
    
    func tileZoomOnUser(animated: Bool){
        guard let currLocation = mapView.userLocation.location else {
            return
        }
        //var LACoordinate = CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437)
        let regionToShow = MKCoordinateRegion(center: currLocation.coordinate, latitudinalMeters: metersRadiusToShow, longitudinalMeters: metersRadiusToShow)
        mapView.setRegion(regionToShow, animated: animated)
        
    }
    
    func regularZoomOnUser(){
        guard let currLocation = mapView.userLocation.location else {
            return
        }
        let regionToShow = MKCoordinateRegion(center: currLocation.coordinate, latitudinalMeters: smallRadiusToDisplay, longitudinalMeters: smallRadiusToDisplay)
        mapView.setRegion(regionToShow, animated: true)
    }
    
    func setUpMap(){
        mapView.delegate = self
        mapView.showsUserLocation = true
        loadMapFromTiles()
        //set Max Zoom if needed
    }
    
    func loadMapFromTiles(){
        mapView.setCameraZoomRange(MKMapView.CameraZoomRange(minCenterCoordinateDistance: tileMinZoom), animated: false)
        overlay.canReplaceMapContent = true
        mapView.addOverlay(overlay, level: .aboveRoads)//change lab els to .aboveLabels to remove labels (puts map custom labels)
    }
    
    func loadRegularMap(){
        mapView.setCameraZoomRange(MKMapView.CameraZoomRange(maxCenterCoordinateDistance: tileMinZoom), animated: false)
        mapView.removeOverlay(overlay)
    }
    
    func getUserLocationAccess(){
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKTileOverlay{
            let renderer = MKTileOverlayRenderer(overlay: overlay)
            return renderer
        }
        else{
            return MKOverlayRenderer()
        }
        
    }
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
    
    
    

}
