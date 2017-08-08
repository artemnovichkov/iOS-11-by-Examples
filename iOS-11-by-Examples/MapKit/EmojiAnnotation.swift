//
//  Annotation.swift
//  iOS-11-by-Examples
//
//  Created by Artem Novichkov on 08/08/2017.
//  Copyright © 2017 Artem Novichkov. All rights reserved.
//

import UIKit
import MapKit

final class EmojiAnnotation: NSObject, MKAnnotation {
    
    enum `Type`: String {
        case good, bad
    }
    
    let title: String?
    let color: UIColor
    let type: Type
    let coordinate: CLLocationCoordinate2D
    
    init(title: String?, color: UIColor, type: Type, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.color = color
        self.type = type
        self.coordinate = coordinate
    }
}
