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

class MapViewController: UIViewController, MKMapViewDelegate {
    var distanceCovered: Double?
    
    @IBOutlet weak var mapView: MKMapView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //mapview setup to show user location
        self.mapView?.delegate = self
//        mapView.showsUserLocation = true
//        mapView.mapType = MKMapType(rawValue: 0)!
//        mapView.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
        let coords1 = CLLocationCoordinate2D(latitude: 52.167894, longitude: 17.077399)
        let coords2 = CLLocationCoordinate2D(latitude: 52.168776, longitude: 17.081326)
        let coords3 = CLLocationCoordinate2D(latitude: 52.167921, longitude: 17.083730)
        let testcoords:[CLLocationCoordinate2D] = [coords1,coords2,coords3]

        let testline = MKPolyline(coordinates: testcoords, count: testcoords.count)
        //Add `MKPolyLine` as an overlay.
        self.mapView?.addOverlay(testline)

        self.mapView?.delegate = self

        self.mapView?.centerCoordinate = coords2
        self.mapView?.region = MKCoordinateRegion(center: coords2, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
    }


    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let testlineRenderer = MKPolylineRenderer(polyline: polyline)
            testlineRenderer.strokeColor = .blue
            testlineRenderer.lineWidth = 2.0
            return testlineRenderer
        }
        return MKOverlayRenderer()
    }

}
