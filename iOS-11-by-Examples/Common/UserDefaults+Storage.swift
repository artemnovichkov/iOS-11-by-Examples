//
//  UserDefaults+Storage.swift
//  iOS-11-by-Examples
//
//  Created by Artem Novichkov on 19/06/2017.
//  Copyright © 2017 Artem Novichkov. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    var blockedNumber: String? {
        get { return string(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }
}
