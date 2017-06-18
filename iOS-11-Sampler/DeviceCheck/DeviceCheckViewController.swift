//
//  DeviceCheckViewController.swift
//  iOS-11-Sampler
//
//  Created by Artem Novichkov on 18/06/2017.
//  Copyright © 2017 Artem Novichkov. All rights reserved.
//

import UIKit
import DeviceCheck

class DeviceCheckViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DCDevice.current.generateToken { data, error in
            print(data ?? "No data")
            print(error ?? "No errors")
        }
    }
}
