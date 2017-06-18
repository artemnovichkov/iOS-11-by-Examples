//
//  ARKitViewController.swift
//  iOS-11-Sampler
//
//  Created by Artem Novichkov on 18/06/2017.
//  Copyright © 2017 Artem Novichkov. All rights reserved.
//

import UIKit
import ARKit

class ARKitViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.showsStatistics = true
        
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingSessionConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
}

extension ARKitViewController: ARSCNViewDelegate {
    
}
