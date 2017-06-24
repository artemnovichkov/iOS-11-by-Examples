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
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = VNDetectFaceLandmarksRequest { [unowned self] request, error in
            self.handle(request, error: error)
        }
        let image = #imageLiteral(resourceName: "face")
        imageView.image = image
        let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
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
            
            let faceRect = observation.boundingBox
            let image = imageView.image!
            let convertedFaceRect = CGRect(x: image.size.width * faceRect.origin.x,
                                           y: image.size.height * (1 - faceRect.origin.y - faceRect.height),
                                           width: image.size.width * faceRect.width,
                                           height: image.size.height * faceRect.height)
            
            let boundingBoxLayer = CAShapeLayer()
            boundingBoxLayer.path = UIBezierPath(rect: convertedFaceRect).cgPath
            boundingBoxLayer.fillColor = nil
            boundingBoxLayer.strokeColor = UIColor.red.cgColor
            imageView.layer.addSublayer(boundingBoxLayer)
            
            layers(for: landmarks.landmarkRegions, rect: convertedFaceRect).forEach { layer in
                self.imageView.layer.addSublayer(layer)
            }
        }
    }
    
    func layers(for regions: [VNFaceLandmarkRegion2D], rect: CGRect) -> [CAShapeLayer] {
        return regions.map { region in
            let points = region.points.map { point in
                return CGPoint(x: rect.minX + point.x * rect.width,
                               y: rect.minY + (1 - point.y) * rect.height)
            }
            
            let layer = self.layer(withPoints: points)
            return layer
        }
    }
    
    func layer(withPoints points: [CGPoint]) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.fillColor = nil
        layer.strokeColor = UIColor.red.cgColor
        let path = UIBezierPath()
        path.move(to: points.first!)
        points.forEach { point in
            path.addLine(to: point)
        }
        layer.path = path.cgPath
        return layer
    }
}

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

extension VNFaceLandmarkRegion2D {
    
    var points: [CGPoint] {
        return (0..<pointCount).map { index in
            let point = self.point(at: index)
            return CGPoint(x: CGFloat(point.x), y: CGFloat(point.y))
        }
    }
}

