//
//  SpriteKitViewController.swift
//  iOS-11-by-Examples
//
//  Created by Michal Kowalski on 31.07.2017.
//  Copyright © 2017 Artem Novichkov. All rights reserved.
//

import UIKit
import SpriteKit

class SKTextNode: SKLabelNode {
    let texts = ["iOS11", "by", "examples"]

    override init() {
        super.init()

        let attributes0 = [
            NSAttributedStringKey.font : UIFont.systemFont(ofSize: 20),
            NSAttributedStringKey.foregroundColor : UIColor.white,
            NSAttributedStringKey.backgroundColor : UIColor.orange
        ]

        let attributes1 = [
            NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 12),
            NSAttributedStringKey.foregroundColor : UIColor.red,
            NSAttributedStringKey.backgroundColor : UIColor.white
        ]

        let attributes2 = [
            NSAttributedStringKey.font : UIFont.italicSystemFont(ofSize: 22),
            NSAttributedStringKey.foregroundColor : UIColor.blue,
            NSAttributedStringKey.backgroundColor : UIColor.clear
        ]

        let string = texts.joined(separator: " ")
        let attrText =  NSMutableAttributedString(string: string)
        attrText.setAttributes(attributes0, range: (string as NSString).range(of: texts[0]))
        attrText.setAttributes(attributes1, range: (string as NSString).range(of: texts[1]))
        attrText.setAttributes(attributes2, range: (string as NSString).range(of: texts[2]))
        attributedText = attrText
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

}

class SpriteKitViewController: UIViewController {

    @IBOutlet weak var skView: SKView!
    var timer: Timer!
    var transformNodeHorizontal: SKTransformNode!
    var transformNodeVertical: SKTransformNode!


    override func viewDidLoad() {
        super.viewDidLoad()

        transformNodeHorizontal = SKTransformNode()
        transformNodeHorizontal.position.y = -50
        transformNodeHorizontal.addChild(SKTextNode())
        skView.scene?.addChild(transformNodeHorizontal)

        transformNodeVertical = SKTransformNode()
        transformNodeVertical.addChild(SKTextNode())
        skView.scene?.addChild(transformNodeVertical)

        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { _ in
            self.updateNode()
        })
    }

    func updateNode() {
        transformNodeVertical.xRotation -= CGFloat.pi/100
        transformNodeHorizontal.yRotation += CGFloat.pi/100
    }
}
