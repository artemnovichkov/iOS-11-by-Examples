//
//  Annotation.swift
//  iOS-11-by-Examples
//
//  Created by Artem Novichkov on 08/08/2017.
//  Copyright © 2017 Artem Novichkov. All rights reserved.
//

import UIKit
import MapKit

final class Annotation: NSObject, MKAnnotation {
    
    let coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init()
    }
}
