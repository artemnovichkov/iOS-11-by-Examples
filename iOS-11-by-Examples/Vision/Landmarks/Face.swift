//
//  Face.swift
//  iOS-11-by-Examples
//
//  Created by Artem Novichkov on 25/06/2017.
//  Copyright © 2017 Artem Novichkov. All rights reserved.
//

import UIKit

struct Face {
    
    let rect: CGRect
    let landmarks: [Landmark]
}

struct Landmark {
    
    let type: LandmarkType
    let points: [CGPoint]
    
    enum LandmarkType: String {
        case faceContour
        case leftEye
        case rightEye
        case leftEyebrow
        case rightEyebrow
        case nose
        case noseCrest
        case medianLine
        case outerLips
        case innerLips
        case leftPupil
        case rightPupil
    }
}
