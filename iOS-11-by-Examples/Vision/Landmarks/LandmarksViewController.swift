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
        let image = #imageLiteral(resourceName: "face")
        imageView.image = image
        let service = LandmarksService()
        service.landmarks(forImage: image) { [unowned self] results in
            switch results {
            case .succes(let faces):
                self.draw(faces)
            case .error(let error):
                print(error)
            }
        }
    }
    
    private func draw(_ faces: [Face]) {
        faces.forEach { face in
            let boundingBoxLayer = CAShapeLayer()
            boundingBoxLayer.path = UIBezierPath(rect: face.rect).cgPath
            boundingBoxLayer.fillColor = nil
            boundingBoxLayer.strokeColor = UIColor.red.cgColor
            imageView.layer.addSublayer(boundingBoxLayer)
            
            face.landmarks.forEach { landmark in
                let points = landmark.points.map { point in
                    return CGPoint(x: face.rect.minX + point.x * face.rect.width,
                                   y: face.rect.minY + (1 - point.y) * face.rect.height)
                }
                
                let layer = self.layer(withPoints: points)
                imageView.layer.addSublayer(layer)
            }
        }
    }
    
    private func layer(withPoints points: [CGPoint]) -> CAShapeLayer {
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

struct Face {
    
    let rect: CGRect
    let landmarks: [Landmark]
}

struct Landmark {
    
    let type: LandmarkType
    let points: [CGPoint]
    
    enum LandmarkType {
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
