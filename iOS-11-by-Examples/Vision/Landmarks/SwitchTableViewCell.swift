//
//  SwitchTableViewCell.swift
//  iOS-11-by-Examples
//
//  Created by Artem Novichkov on 25/06/2017.
//  Copyright © 2017 Artem Novichkov. All rights reserved.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var `switch`: UISwitch!
    
    var line: LandmarkLine? {
        didSet {
            if let line = line {
                titleLabel.text = line.description
                `switch`.isOn = !line.layer.isHidden
            }
        }
    }
    
    @IBAction func valueChanged(_ sender: Any) {
        line?.layer.isHidden = !`switch`.isOn
    }
}
