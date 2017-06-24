//
//  LandmarksViewController.swift
//  iOS-11-by-Examples
//
//  Created by Artem Novichkov on 24/06/2017.
//  Copyright © 2017 Artem Novichkov. All rights reserved.
//

import UIKit
import Vision

class LandmarksViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let request = VNDetectFaceLandmarksRequest { [unowned self] request, error in
            self.handle(request, error: error)
        }
        let image = #imageLiteral(resourceName: "face").cgImage!
        let handler = VNImageRequestHandler(cgImage: image, options: [:])
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }
    
    fileprivate func handle(_ request: VNRequest, error: Error?) {
        if let error = error {
            print(error)
            return
        }
        guard let observations = request.results as? [VNFaceObservation] else {
            return
        }
        for observation in observations {
            guard let landmarks = observation.landmarks else {
                continue
            }
            let boundingBox = observation.boundingBox
            print(landmarks.landmarkRegions)
        }
    }
}

extension VNFaceLandmarks2D {
    
    var landmarkRegions: [VNFaceLandmarkRegion2D] {
        var landmarkRegions = [VNFaceLandmarkRegion2D]()
        if let faceContour = faceContour {
            landmarkRegions.append(faceContour)
        }
        return landmarkRegions
    }
}
