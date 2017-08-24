//
//  FaceDetectionViewController.swift
//  iOS-11-by-Examples
//
//  Created by Artem Novichkov on 17/06/2017.
//  Copyright © 2017 Artem Novichkov. All rights reserved.
//

import UIKit
import Vision

class FaceDetectionViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func process(_ image: UIImage) {
        imageView.image = image
        guard let ciImage = CIImage(image: image) else {
            return
        }
        let request = VNDetectFaceRectanglesRequest { [unowned self] request, error in
            if let error = error {
                self.presentAlertController(withTitle: self.title,
                                            message: error.localizedDescription)
            }
            else {
                self.handleFaces(with: request)
            }
        }
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        do {
            try handler.perform([request])
        }
        catch {
            presentAlertController(withTitle: title,
                                   message: error.localizedDescription)
        }
    }
    
    func handleFaces(with request: VNRequest) {
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
        let imagePickerController = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
            imagePickerController.cameraDevice = .front
        }
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
}

extension FaceDetectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else {
            return
        }
        process(image)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
