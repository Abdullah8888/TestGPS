//
//  MapViewController.swift
//  TestGPS
//
//  Created by Jimoh Babatunde  on 07/08/2020.
//  Copyright © 2020 Tunde. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapPin : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?

    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}

class MapViewController: UIViewController, MKMapViewDelegate {
    var distanceCovered: Double?
    var sourceLocation: CLLocationCoordinate2D?
    var destinationLocation: CLLocationCoordinate2D?
    
    @IBOutlet weak var distCoveredLabel: UILabel?
    @IBOutlet weak var mapView: MKMapView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //mapview setup to show user location
        self.mapView?.delegate = self
//        mapView.showsUserLocation = true

        let sourcePin = MapPin(coordinate: sourceLocation!, title: "source", subtitle: "")
        let destinationPin = MapPin(coordinate: destinationLocation!, title: "destination", subtitle: "")
        self.mapView?.addAnnotation(sourcePin)
        self.mapView?.addAnnotation(destinationPin)
        
        let sourcePlaceMark = MKPlacemark(coordinate: sourceLocation!)
        let destinationPlaceMark = MKPlacemark(coordinate: destinationLocation!)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: sourcePlaceMark)
        directionRequest.destination = MKMapItem(placemark: destinationPlaceMark)
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard let directionResponse = response else {
                if let er = error {
                    print("error in getting directions == \(er.localizedDescription)")
                }
                return
            }
            
            let route = directionResponse.routes[0]
            self.mapView?.addOverlay(route.polyline, level: .aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView?.setRegion(MKCoordinateRegion(rect), animated: true)
        }

        self.distCoveredLabel?.text = String(format: "Total distance covered = %0.3f %@", distanceCovered!/1000, "km")
    }

    //MARK;- Mapkit delegate
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .red
        renderer.lineWidth = 4.0
        
        return renderer
    }

}
