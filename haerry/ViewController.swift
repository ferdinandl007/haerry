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
import RestKit
import VisualRecognitionV3


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
    let longArry = [51.545360,51.546360,51.543360,51.544360,51.544360,51.544360]
    let latArry = [-0.020320,-0.021020,-0.020520,-0.020020,-0.019020,-0.020120]
    private var bool = true
    var lavel = 1
    var item = 3
    weak var timer = Timer()
    let apiKey = "a10012db543b7e41e69acc9087619f2a52582d29"
    let version = "2016-12-1"

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    initializeLocationManager()
    animtor = UIDynamicAnimator(referenceView: self.view)
    self.view.layoutIfNeeded()

        
        for i in 1...5 {
            let point = MGLPointAnnotation()
            point.coordinate = CLLocationCoordinate2D(latitude: longArry[i], longitude: latArry[i])
            point.title = "plaer"
            self.mapView.addAnnotation(point)
        }
        

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
            mapView.setCenter(userLocachon, zoomLevel: 17, animated: true)
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
        
        let rec = VisualRecognition(apiKey: apiKey, version: version)

        // Pic of a Dog
        let recogURL = URL(string: "https://visual-recognition-demo.mybluemix.net/images/samples/5.jpg")!
        let failure = {(error: Error) in
            print(error)
        }
        
        
         rec.classify(image: recogURL.absoluteString, failure: failure) { ClassifiedImages in
            
            if let ClassifiedImage = ClassifiedImages.images.first {
                print(ClassifiedImage.classifiers)
                
                if let classification = ClassifiedImage.classifiers.first!.classes.first?.classification {
                    
                    DispatchQueue.main.async {
                        
                        
                        //self.label.text = classification
                        print(classification)
                        self.item += 1
                        self.spellitem.text = "\(self.item)"
                        
                        self.alertTheUser(title: "new spell", message: "have a new spell banana")
                    }
                    
                }
                
            } else {
                
                print("NOOOO")
            }
            
        }
        
    
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always try to show a callout when an annotation is tapped.
        return true
    }
    private func alertTheUser(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil);
    }

   

}

