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
    lazy var samples = [Sample(title: "Vision", description: "Vision description", storyboardName: "Vision"),
                        Sample(title: "Core ML", description: "Core ML description", storyboardName: "CoreML"),
                        Sample(title: "IdentityLookup", description: "Filter unwanted SMS and MMS messages", storyboardName: "IdentityLookup"),
                        Sample(title: "Core NFC", description: "Reading of NFC tags", storyboardName: "CoreNFC")]
}
