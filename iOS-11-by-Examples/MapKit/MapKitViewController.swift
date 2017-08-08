//
//  MapKitViewController.swift
//  iOS-11-by-Examples
//
//  Created by Artem Novichkov on 08/08/2017.
//  Copyright © 2017 Artem Novichkov. All rights reserved.
//

import UIKit
import MapKit

class MapKitViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        //New map type
        mapView.mapType = .mutedStandard
        mapView.delegate = self
        mapView.register(MarkerAnnotationView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        let test1 = Annotation(coordinate: CLLocationCoordinate2DMake(55.7, 37.6))
        let test2 = Annotation(coordinate: CLLocationCoordinate2DMake(55.7, 37.7))
        mapView.addAnnotation(test1)
        mapView.addAnnotation(test2)
    }
}

extension MapKitViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, clusterAnnotationForMemberAnnotations memberAnnotations: [MKAnnotation]) -> MKClusterAnnotation {
        return MKClusterAnnotation(memberAnnotations: memberAnnotations)
    }
}
