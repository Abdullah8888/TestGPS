//
//  ViewController.swift
//  TestGPS
//
//  Created by Jimoh Babatunde  on 07/08/2020.
//  Copyright © 2020 Tunde. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    // Used to start getting the users location
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var latLngLabel: UILabel?
    @IBOutlet weak var btnStart: UIButton?
    @IBOutlet weak var btnShowDistOnMap: UIButton?
    private var check: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // For use when the app is open & in the background
        locationManager.requestAlwaysAuthorization()
        
        // If location services is enabled get the users location
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest // You can change the locaiton accuary here.
            locationManager.allowsBackgroundLocationUpdates = true
        }
        
        
    }
    
    // Print out the location to the console
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.latLngLabel?.text = "Lat : \(location.coordinate.latitude) \nLng : \(location.coordinate.longitude)"
            PersistenceManager.sharedManager.saveCoordinateData(location.coordinate.latitude.description, location.coordinate.longitude.description)
           
        }
    }
    
    // If we have been deined access give the user the option to change it
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.denied) {
            showLocationDisabledPopUp()
        }
    }
    
    // Show the popup to the user if we have been deined access
    func showLocationDisabledPopUp() {
        let alertController = UIAlertController(title: "Background Location Access Disabled",
                                                message: "In order to deliver pizza we need your location",
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(openAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func initiateCoOrdinateCapturing(_ sender: UIButton) {
        if check == false {
            PersistenceManager.sharedManager.clearData()
            btnStart?.setTitle("Stop", for: .normal)
            locationManager.startUpdatingLocation()
            check = true
            
        }
        else {
            btnStart?.setTitle("Start", for: .normal)
            locationManager.stopUpdatingLocation()
            check = false
        }
    }
    
    @IBAction func showMap(_ sender: UIButton) {
        let data = PersistenceManager.sharedManager.getAll()
        if data.count > 1 {
            let firstElement = data[0]
            let lastElement = data[data.count-1]
            let startPoint = CLLocation(latitude: Double(firstElement["lat"]!)!, longitude: Double(firstElement["lng"]!)!)
            let stopPoint = CLLocation(latitude: Double(lastElement["lat"]!)!, longitude: Double(lastElement["lng"]!)!)
            let distance = startPoint.distance(from: stopPoint)
            print("the distance is \(distance)")
            
            let mapViewController = MapViewController(nibName: "MapViewController", bundle: nil)
            mapViewController.distanceCovered = 89.0
            self.navigationController?.pushViewController(mapViewController, animated: true)
            
        }
        else {
            self.showPopUp()
        }
        
        
    }
    
    func showPopUp() {
        let alertController = UIAlertController(title: "Device Coordinate Not Found",
                                                message: "Click on the start button to track device coordinate",
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    
}

