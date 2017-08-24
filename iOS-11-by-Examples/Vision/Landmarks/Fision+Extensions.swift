//
//  Fision+Extensions.swift
//  iOS-11-by-Examples
//
//  Created by Artem Novichkov on 25/06/2017.
//  Copyright © 2017 Artem Novichkov. All rights reserved.
//

import Vision

extension VNFaceLandmarks2D {
    
    var landmarkRegions: [VNFaceLandmarkRegion2D] {
        var landmarkRegions = [VNFaceLandmarkRegion2D]()
        if let faceContour = faceContour {
            landmarkRegions.append(faceContour)
        }
        if let leftEye = leftEye {
            landmarkRegions.append(leftEye)
        }
        if let rightEye = rightEye {
            landmarkRegions.append(rightEye)
        }
        if let nose = nose {
            landmarkRegions.append(nose)
        }
        if let outerLips = outerLips {
            landmarkRegions.append(outerLips)
        }
        return landmarkRegions
    }
}
