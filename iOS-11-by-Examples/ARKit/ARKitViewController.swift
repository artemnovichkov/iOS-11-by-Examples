//
//  ARKitViewController.swift
//  iOS-11-by-Examples
//
//  Created by Artem Novichkov on 18/06/2017.
//  Copyright © 2017 Artem Novichkov. All rights reserved.
//

import UIKit
import ARKit

class ARKitViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    var treeNode: SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.showsStatistics = true
        
        let scene = SCNScene(named: "art.scnassets/lowpoly_tree_sample.dae")!
        sceneView.scene = scene
        treeNode = scene.rootNode.childNode(withName: "Tree_lp_11", recursively: true)
        treeNode?.position = SCNVector3Make(0, 0, -1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        let results = sceneView.hitTest(touch.location(in: sceneView), types: [.featurePoint])
        guard let hitFeature = results.last else { return }
        let hitTransform = SCNMatrix4(hitFeature.worldTransform)
        let hitPosition = SCNVector3Make(hitTransform.m41,
                                         hitTransform.m42,
                                         hitTransform.m43)
        let newTreeNode = treeNode!.clone()
        newTreeNode.position = hitPosition
        sceneView.scene.rootNode.addChildNode(newTreeNode)
    }
}

extension ARKitViewController: ARSCNViewDelegate {
    
}
