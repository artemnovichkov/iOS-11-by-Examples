//
//  LandmarksService.swift
//  iOS-11-by-Examples
//
//  Created by Artem Novichkov on 25/06/2017.
//  Copyright © 2017 Artem Novichkov. All rights reserved.
//

import Vision
import UIKit

final class LandmarksService {
    
    enum Results {
        case succes([Face]), error(Swift.Error)
    }
    
    enum Error: Swift.Error {
        case emptyResults
    }
    
    func landmarks(forImage image: UIImage, completion: @escaping (Results) -> Void) {
        let request = VNDetectFaceLandmarksRequest { [unowned self] request, error in
            if let error = error {
                completion(.error(error))
                return
            }
            self.handle(request, image: image, completion: completion)
        }
        let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
        do {
            try handler.perform([request])
        }
        catch {
            completion(.error(error))
        }
    }
    
    private func handle(_ request: VNRequest, image: UIImage, completion: (Results) -> Void) {
        guard let observations = request.results as? [VNFaceObservation] else {
            completion(.error(Error.emptyResults))
            return
        }
        
        let faces: [Face] = observations.map { observation in
            var finalLandmarks = [Landmark]()
            if let landmarks = observation.landmarks {
                finalLandmarks.append(contentsOf: convert(landmarks: landmarks))
            }
            
            let faceRect = observation.boundingBox
            let convertedFaceRect = CGRect(x: image.size.width * faceRect.origin.x,
                                           y: image.size.height * (1 - faceRect.origin.y - faceRect.height),
                                           width: image.size.width * faceRect.width,
                                           height: image.size.height * faceRect.height)
            return Face(rect: convertedFaceRect, landmarks: finalLandmarks)
        }
        completion(.succes(faces))
    }
    
    private func convert(landmarks: VNFaceLandmarks2D) -> [Landmark] {
        var finalLandmarks = [Landmark]()
        if let faceContour = landmarks.faceContour {
            finalLandmarks.append(Landmark(type: .faceContour, points: faceContour.normalizedPoints))
        }
        if let leftEye = landmarks.leftEye {
            finalLandmarks.append(Landmark(type: .leftEye, points: leftEye.normalizedPoints))
        }
        if let rightEye = landmarks.rightEye {
            finalLandmarks.append(Landmark(type: .rightEye, points: rightEye.normalizedPoints))
        }
        if let nose = landmarks.nose {
            finalLandmarks.append(Landmark(type: .nose, points: nose.normalizedPoints))
        }
        if let outerLips = landmarks.outerLips {
            finalLandmarks.append(Landmark(type: .outerLips, points: outerLips.normalizedPoints))
        }
        return finalLandmarks
    }
}
