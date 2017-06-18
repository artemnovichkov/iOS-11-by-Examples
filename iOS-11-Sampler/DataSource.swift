//
//  DataSource.swift
//  iOS-11-Sampler
//
//  Created by Artem Novichkov on 17/06/2017.
//  Copyright © 2017 Artem Novichkov. All rights reserved.
//

import UIKit

struct Sample {
    let title: String
    let description: String
    let storyboardName: String
    
    var controller: UIViewController? {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let viewController = storyboard.instantiateInitialViewController()
        viewController?.title = title
        return viewController
    }
}

struct DataSource {
    lazy var samples = [Sample(title: "🤖 Core ML", description: "Object classification using Core ML framework", storyboardName: "CoreML"),
                        Sample(title: "👀 Vision", description: "Face detection using Vision framework", storyboardName: "Vision"),
                        Sample(title: "🚀 ARKit", description: "Augmented reality experiences in your app or game", storyboardName: "ARKit"),
                        Sample(title: "🔖 Core NFC", description: "Reading of NFC tags", storyboardName: "CoreNFC"),
                        Sample(title: "✉️ IdentityLookup", description: "Filter unwanted SMS and MMS messages", storyboardName: "IdentityLookup"),
                        Sample(title: "📱 DeviceCheck", description: "Generating unique per-device or per-user identifier", storyboardName: "DeviceCheck")]
}
