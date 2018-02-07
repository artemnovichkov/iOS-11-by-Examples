//
//  UIImage+Processing.swift
//  iOS-11-by-Examples
//
//  Created by Artem Novichkov on 18/06/2017.
//  Copyright © 2017 Artem Novichkov. All rights reserved.
//

import UIKit

extension UIImage {
    
    func resize(newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        return newImage
    }
    
    var pixelBuffer: CVPixelBuffer? {
        guard let newImage = resize(newSize: CGSize(width: 149.5, height: 149.5)) else {
            print("Can't get image from current context")
            return nil
        }
        
        guard let ciimage = CIImage(image: newImage) else {
            print("Can't get CI image")
            return nil
        }
        
        let tempContext = CIContext(options: nil)
        guard let cgImage = tempContext.createCGImage(ciimage, from: ciimage.extent) else {
            print("Can't get CI image from context")
            return nil
        }
        
        let cfnumPointer = UnsafeMutablePointer<UnsafeRawPointer>.allocate(capacity: 1)
        let cfnum = CFNumberCreate(kCFAllocatorDefault, .intType, cfnumPointer)
        let keys: [CFString] = [kCVPixelBufferCGImageCompatibilityKey,
                                kCVPixelBufferCGBitmapContextCompatibilityKey,
                                kCVPixelBufferBytesPerRowAlignmentKey]
        let values: [CFTypeRef] = [kCFBooleanTrue, kCFBooleanTrue, cfnum!]
        let keysPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 1)
        let valuesPointer =  UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 1)
        keysPointer.initialize(to: keys)
        valuesPointer.initialize(to: values)
        
        let options = CFDictionaryCreate(kCFAllocatorDefault, keysPointer, valuesPointer, keys.count, nil, nil)
        
        let width = cgImage.width
        let height = cgImage.height
        
        var initializingBuffer: CVPixelBuffer?
        CVPixelBufferCreate(kCFAllocatorDefault,
                                         width,
                                         height,
                                         kCVPixelFormatType_32BGRA,
                                         options,
                                         &initializingBuffer)
        
        guard let pixelBuffer = initializingBuffer else {
            print("Encountered error during CVPixelBufferCreate")
            return nil
        }
        
        var status = CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        
        guard status == kCVReturnSuccess else {
            print("Pixel buffer: \(pixelBuffer)")
            print("CVPixelBufferLockBaseAddress status \(status)")
            return nil
        }
        
        let bufferAddress = CVPixelBufferGetBaseAddress(pixelBuffer)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesperrow = CVPixelBufferGetBytesPerRow(pixelBuffer)
        let context = CGContext(data: bufferAddress,
                                width: width,
                                height: height,
                                bitsPerComponent: 8,
                                bytesPerRow: bytesperrow,
                                space: rgbColorSpace,
                                bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)
        context?.concatenate(CGAffineTransform(rotationAngle: 0))
        context?.concatenate(__CGAffineTransformMake( 1, 0, 0, -1, 0, CGFloat(height) )) //Flip Vertical
        
        context?.draw(cgImage, in: CGRect(origin: .zero, size: CGSize(width: width, height: width)))
        status = CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        
        guard status == kCVReturnSuccess else {
            print("Pixel buffer: \(pixelBuffer)")
            print("CVPixelBufferUnlockBaseAddress status \(status)")
            return nil
        }
        
        return pixelBuffer
    }
}
