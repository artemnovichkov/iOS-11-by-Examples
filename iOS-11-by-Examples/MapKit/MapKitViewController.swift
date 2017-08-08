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
    
    let annotations: [Annotation] = {
        let brown = Annotation(title: "🤡",
                               color: .brown,
                               coordinate: CLLocationCoordinate2DMake(55.7, 37.6))
        let gray = Annotation(title: "💩",
                              color: .gray,
                              coordinate: CLLocationCoordinate2DMake(55.7, 37.7))
        return [brown, gray]
    }()
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //New map type
        //        mapView.mapType = .mutedStandard
        mapView.delegate = self
        mapView.register(MarkerAnnotationView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        mapView.addAnnotations(annotations)
    }
}

extension MapKitViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, clusterAnnotationForMemberAnnotations memberAnnotations: [MKAnnotation]) -> MKClusterAnnotation {
        return MKClusterAnnotation(memberAnnotations: memberAnnotations)
    }
}
