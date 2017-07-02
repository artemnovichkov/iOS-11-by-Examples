//
//  CoreImageFiltersViewController.swift
//  iOS-11-by-Examples
//
//  Created by Artem Novichkov on 02/07/2017.
//  Copyright © 2017 Artem Novichkov. All rights reserved.
//

import UIKit

class CoreImageFiltersViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var filters = [CIFilter]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        
        filters = CIFilter.iOS11Filters
        pickerView.selectRow(0, inComponent: 0, animated: false)
    }
    
    func apply(filter: CIFilter) {
        activityIndicatorView.startAnimating()
        DispatchQueue.global().async {
            print(filter.attributes)
            if filter.attributes[kCIInputImageKey] == nil {
                print("\(filter.name) has no inputImage property.")
                return
            }
            
            let context = CIContext(options: nil)
            let originalImage = CIImage(image: #imageLiteral(resourceName: "face"))
            filter.setValue(originalImage, forKey: kCIInputImageKey)
            
            guard let outputImage = filter.outputImage else {
                print("No output image")
                return
            }
            guard let image = context.createCGImage(outputImage, from: outputImage.extent) else {
                print("can't create image")
                return
            }
            let finalImage = UIImage(cgImage: image)
            DispatchQueue.main.async {
                self.activityIndicatorView.stopAnimating()
                self.imageView.image = finalImage
            }
        }
    }
}

extension CoreImageFiltersViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return filters.count
    }
}

extension CoreImageFiltersViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return filters[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        apply(filter: filters[row])
    }
}

extension CIFilter {
    
    static var iOS11Filters: [CIFilter] {
        let allFilters = CIFilter.filterNames(inCategory: kCICategoryBuiltIn).flatMap { name in
            return CIFilter(name: name)
        }
        return allFilters.filter { $0.availableiOS == 11 }
    }
    
    var availableiOS: Float {
        guard let version = attributes[kCIAttributeFilterAvailable_iOS] as? String,
            let versionNumber = Float(version) else {
                return 0
        }
        return versionNumber
    }
}
