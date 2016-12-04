//
//  ViewController.swift
//  haerry
//
//  Created by Ferdinand Lösch on 03/12/2016.
//  Copyright © 2016 Ferdinand Lösch. All rights reserved.
//

import UIKit
import Mapbox
import MapKit
import CoreLocation
import PubNub

protocol Controller: class {
    func location(lat: [CLLocationCoordinate2D])
}

class ViewController: UIViewController,MGLMapViewDelegate , CLLocationManagerDelegate, PNObjectEventListener {

    @IBOutlet weak var View2: UIView!
    @IBOutlet weak var spellitem: UILabel!
    @IBOutlet weak var wizLevel: UILabel!
    @IBOutlet weak var mapView: MGLMapView!
    private var locationManager = CLLocationManager();
    private var userLocachon: CLLocationCoordinate2D!
    private var mosterLoachon: [CLLocationCoordinate2D?] = []
    private var snap: UISnapBehavior!
    private var animtor: UIDynamicAnimator!
    
    private var bool = true
    var lavel = 1
    var item = 3
    weak var timer = Timer()
  
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    initializeLocationManager()
    animtor = UIDynamicAnimator(referenceView: self.view)
    self.view.layoutIfNeeded()


    }
    
    func location(lat: [Dictionary]) {
        
    }

        
        // Do any additional setup after loading the view, typically from a nib.
    private func initializeLocationManager() {
        locationManager.delegate = self
        mapView.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.requestWhenInUseAuthorization();
        locationManager.startUpdatingLocation();
        
    }

    
    

    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // if we have the coordinates from the manager
        if let location = locationManager.location?.coordinate {
            print(location)
            userLocachon = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            mapView.setCenter(userLocachon, zoomLevel: 15, animated: true)
            myPosition(lat: Double(location.latitude), long: Double(location.longitude), name: 01122)
        }
        
        
    }
   
    func myPosition(lat: Double, long: Double, name: Double){
        
        let data: [String: Double] = [ "latitude" : lat, "longitude": long, "playerID": 1.0 ]
            
        UIApplication.shared.client.publish(data, toChannel: "location", withCompletion: {(status) in
            
        
        })

    
}
    
    

    func battel(){
        self.performSegue(withIdentifier: "bob", sender: nil)
        lavel += 1
        timer?.invalidate()
    }
    


    
    @IBAction func signOut(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func meButton(_ sender: Any) {
       
        animtor.removeAllBehaviors()

        if bool {
            snap = UISnapBehavior(item: View2, snapTo: CGPoint(x: self.view.frame.width / 2, y: 640))
            
          bool = false
        } else {
            snap = UISnapBehavior(item: View2, snapTo: CGPoint(x: self.view.frame.width / 2, y: 790))
             self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(3), target: self, selector: #selector(ViewController.battel), userInfo: nil, repeats: false)
            bool = true
        }
        animtor.addBehavior(snap)
        
          }
    @IBAction func spellButton(_ sender: Any) {
        
        item += 1
        spellitem.text = "\(item)"

    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always try to show a callout when an annotation is tapped.
        return true
    }
 
   

}

