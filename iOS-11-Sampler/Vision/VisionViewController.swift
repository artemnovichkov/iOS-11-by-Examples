//
//  VisionViewController.swift
//  iOS-11-Sampler
//
//  Created by Artem Novichkov on 17/06/2017.
//  Copyright © 2017 Artem Novichkov. All rights reserved.
//

import UIKit
import Vision

class VisionViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func start(with image: UIImage) {
        imageView.image = image
        guard let ciImage = CIImage(image: image) else {
            return
        }
        let request = VNDetectFaceRectanglesRequest { [unowned self] request, error in
            if let error = error {
                print(error)
            }
            else {
                self.handleFaces(request: request)
            }
        }
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        do {
            try handler.perform([request])
        }
        catch {
            print(error)
        }
    }
    
    func handleFaces(request: VNRequest) {
        imageView.layer.sublayers?.forEach { layer in
            layer.removeFromSuperlayer()
        }
        guard let observations = request.results as? [VNFaceObservation] else {
            return
        }
        observations.forEach { observation in
            let boundingBox = observation.boundingBox
            let size = CGSize(width: boundingBox.width * imageView.bounds.width,
                              height: boundingBox.height * imageView.bounds.height)
            let origin = CGPoint(x: boundingBox.minX * imageView.bounds.width,
                                 y: (1 - observation.boundingBox.minY) * imageView.bounds.height - size.height)
            
            let layer = CAShapeLayer()
            layer.frame = CGRect(origin: origin, size: size)
            layer.borderColor = UIColor.red.cgColor
            layer.borderWidth = 2
            
            imageView.layer.addSublayer(layer)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func photoButtonAction(_ sender: Any) {
        let vc = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            vc.sourceType = .camera
        }
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true, completion: nil)
    }
}

extension VisionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else {
            return
        }
        start(with: image)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
