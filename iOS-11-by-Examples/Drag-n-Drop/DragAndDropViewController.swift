//
//  DragAndDropViewController.swift
//  iOS-11-by-Examples
//
//  Created by Artem Novichkov on 11/07/2017.
//  Copyright © 2017 Artem Novichkov. All rights reserved.
//

import UIKit

final class DragAndDropViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    @IBAction func barButtonItemAction(_ sender: Any) {
        let imagesViewController = ImagesViewController()
        navigationController?.pushViewController(imagesViewController, animated: true)
    }
}
