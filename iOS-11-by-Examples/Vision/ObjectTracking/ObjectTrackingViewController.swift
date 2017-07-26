//
//  ObjectTrackingViewController.swift
//  iOS-11-by-Examples
//
//  Created by Artem Novichkov on 20/06/2017.
//  Copyright © 2017 Artem Novichkov. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

class ObjectTrackingViewController: UIViewController {
    
    private lazy var captureSession: AVCaptureSession = {
        let session = AVCaptureSession()
        session.sessionPreset = AVCaptureSession.Preset.photo
        guard let backCamera = AVCaptureDevice.default(for: .video),
            let input = try? AVCaptureDeviceInput(device: backCamera) else {
                return session
        }
        session.addInput(input)
        return session
    }()
    private lazy var cameraLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
    
    private let handler = VNSequenceRequestHandler()
    fileprivate var lastObservation: VNDetectedObjectObservation?
    
    lazy var highlightView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.red.cgColor
        view.layer.borderWidth = 4
        view.backgroundColor = .clear
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.addSublayer(cameraLayer)
        view.addSubview(highlightView)
        
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "queue"))
        captureSession.addOutput(output)
        
        captureSession.startRunning()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cameraLayer.frame = view.bounds
    }
    
    // MARK: - Actions
    
    @objc private func tapAction(recognizer: UITapGestureRecognizer) {
        highlightView.frame.size = CGSize(width: 120, height: 120)
        highlightView.center = recognizer.location(in: view)
        
        let originalRect = highlightView.frame
        var convertedRect = cameraLayer.metadataOutputRectConverted(fromLayerRect: originalRect)
        convertedRect.origin.y = 1 - convertedRect.origin.y
        
        lastObservation = VNDetectedObjectObservation(boundingBox: convertedRect)
    }
    
    fileprivate func handle(_ request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let newObservation = request.results?.first as? VNDetectedObjectObservation else {
                return
            }
            self.lastObservation = newObservation
            
            var transformedRect = newObservation.boundingBox
            transformedRect.origin.y = 1 - transformedRect.origin.y
            let convertedRect = self.cameraLayer.layerRectConverted(fromMetadataOutputRect: transformedRect)
            self.highlightView.frame = convertedRect
        }
    }
}

extension ObjectTrackingViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer),
            let observation = lastObservation else {
                return
        }
        let request = VNTrackObjectRequest(detectedObjectObservation: observation) { [unowned self] request, error in
            self.handle(request, error: error)
        }
        request.trackingLevel = .accurate
        do {
            try handler.perform([request], on: pixelBuffer)
        }
        catch {
            print(error)
        }
    }
}
