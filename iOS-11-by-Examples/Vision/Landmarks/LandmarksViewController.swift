//
//  LandmarksViewController.swift
//  iOS-11-by-Examples
//
//  Created by Artem Novichkov on 24/06/2017.
//  Copyright © 2017 Artem Novichkov. All rights reserved.
//

import UIKit
import Vision

struct LandmarkLine {
    var description: String
    var layer: CAShapeLayer
}

class LandmarksViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var lines = [LandmarkLine]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
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
            
            let lines: [LandmarkLine] = face.landmarks.map { landmark in
                let points = landmark.points.map { point in
                    return CGPoint(x: face.rect.minX + point.x * face.rect.width,
                                   y: face.rect.minY + (1 - point.y) * face.rect.height)
                }
                
                let layer = self.layer(withPoints: points)
                return LandmarkLine(description: landmark.type.rawValue,
                                    layer: layer)
            }
            lines.forEach { line in
                imageView.layer.addSublayer(line.layer)
            }
            self.lines = lines
        }
    }
    
    private func layer(withPoints points: [CGPoint]) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.fillColor = nil
        layer.strokeColor = UIColor.red.cgColor
        layer.lineWidth = 2
        let path = UIBezierPath()
        path.move(to: points.first!)
        points.forEach { point in
            path.addLine(to: point)
        }
        layer.path = path.cgPath
        return layer
    }
}

extension LandmarksViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SwitchCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SwitchTableViewCell
        
        cell.line = lines[indexPath.row]
        
        return cell
    }
}
