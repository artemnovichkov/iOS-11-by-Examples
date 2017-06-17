//
//  CoreMLViewController.swift
//  iOS-11-Sampler
//
//  Created by Artem Novichkov on 17/06/2017.
//  Copyright © 2017 Artem Novichkov. All rights reserved.
//

import UIKit
import Vision

class CoreMLViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func process(_ image: UIImage) {
        imageView.image = image
        guard let ciImage = CIImage(image: image) else {
            return
        }
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            return
        }
        let request = VNCoreMLRequest(model: model) { [unowned self] request, error in
            if let error = error {
                print(error)
            }
            else {
                self.handleObjects(with: request)
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
    
    func handleObjects(with request: VNRequest) {
        guard let results = request.results as? [VNClassificationObservation] else {
            fatalError("Results Error")
        }
        
        if let observation = results.first {
            label.text = "\(observation.identifier) \(observation.confidence)"
        }
    }
    @IBAction func buttonAction(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
        }
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
}

extension CoreMLViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
