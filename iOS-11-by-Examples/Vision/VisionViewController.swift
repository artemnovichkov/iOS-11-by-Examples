//
//  VisionViewController.swift
//  iOS-11-by-Examples
//
//  Created by Artem Novichkov on 20/06/2017.
//  Copyright © 2017 Artem Novichkov. All rights reserved.
//

import UIKit

class VisionViewController: UITableViewController {
    
    lazy var visionExamples = [Example(title: "😀 Face Detection",
                                       description: "Detect faces on photo",
                                       storyboardName: "Vision",
                                       controllerID: "FaceDetection"),
                               Example(title: "🔬 Object Tracking",
                                       description: "Track object with camera",
                                       storyboardName: "Vision",
                                       controllerID: "ObjectTracking"),
                               Example(title: "🤥 Landmarks",
                                       description: "Detects face features on photo",
                                       storyboardName: "Vision",
                                       controllerID: "Landmarks")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
}

extension VisionViewController {
    
    // MARK: UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visionExamples.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let sample = visionExamples[indexPath.row]
        cell.textLabel?.text = sample.title
        cell.detailTextLabel?.text = sample.description
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sample = visionExamples[indexPath.row]
        if let controller = sample.controller {
            navigationController?.pushViewController(controller, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
