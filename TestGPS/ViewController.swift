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
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.allowsBackgroundLocationUpdates = true
        }
        
        
    }
    
    //MARK:- CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.latLngLabel?.text = "Lat : \(location.coordinate.latitude) \nLng : \(location.coordinate.longitude)"
            PersistenceManager.sharedManager.saveCoordinateData(location.coordinate.latitude.description, location.coordinate.longitude.description)
           
        }
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
            let locData = data.map { (item) -> CLLocation in
                CLLocation(latitude: Double(item["lat"]!)!, longitude: Double(item["lng"]!)!)
            }
            let totalDistance = locData.reduce((0.0, nil), { ($0.0 + $1.distance(from: $0.1 ?? $1), $1) }).0
            let mapViewController = MapViewController(nibName: "MapViewController", bundle: nil)
            mapViewController.distanceCovered = totalDistance
            mapViewController.sourceLocation = CLLocationCoordinate2D(latitude: startPoint.coordinate.latitude, longitude: startPoint.coordinate.longitude)
            mapViewController.destinationLocation = CLLocationCoordinate2D(latitude: stopPoint.coordinate.latitude, longitude: stopPoint.coordinate.longitude)
            self.navigationController?.pushViewController(mapViewController, animated: true)
            
        }
        else {
            self.showPopUp()
        }
        
        
    }
    
    func showPopUp() {
        let alertController = UIAlertController(title: "No Coordinate Found",
                                                message: "Click on the start button to start tracking",
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    
}

