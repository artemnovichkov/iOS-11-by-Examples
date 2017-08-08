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
    
    let annotations: [EmojiAnnotation] = {
        let clown = EmojiAnnotation(title: "🤡",
                               color: .brown,
                               type: .good,
                               coordinate: CLLocationCoordinate2DMake(54.98, 73.30))
        let developer = EmojiAnnotation(title: "👨🏻‍💻",
                               color: .red,
                               type: .good,
                               coordinate: CLLocationCoordinate2DMake(54.98, 73.301))
        let shit = EmojiAnnotation(title: "💩",
                              color: .gray,
                              type: .bad,
                              coordinate: CLLocationCoordinate2DMake(54.98, 73.305))
        return [clown, developer, shit]
    }()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let coordinate = CLLocationCoordinate2DMake(54.98, 73.32)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, 5000, 5000)
        mapView.setRegion(coordinateRegion, animated: true)
        
        //New map type
        mapView.mapType = .mutedStandard
        mapView.delegate = self
        mapView.register(MarkerAnnotationView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        mapView.addAnnotations(annotations)
    }
}

extension MapKitViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, clusterAnnotationForMemberAnnotations memberAnnotations: [MKAnnotation]) -> MKClusterAnnotation {
        let test = MKClusterAnnotation(memberAnnotations: memberAnnotations)
        test.title = "Emojis"
        test.subtitle = nil
        return test
    }
}
