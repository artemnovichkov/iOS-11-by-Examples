//
//  UIViewController+Alert.swift
//  iOS-11-by-Examples
//
//  Created by Artem Novichkov on 19/06/2017.
//  Copyright © 2017 Artem Novichkov. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentAlertController(withTitle title: String?, message: String?) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok",
                                                style: .default,
                                                handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
