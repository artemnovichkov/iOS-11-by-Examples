//
//  DragAndDropViewController.swift
//  iOS-11-by-Examples
//
//  Created by Artem Novichkov on 11/07/2017.
//  Copyright © 2017 Artem Novichkov. All rights reserved.
//

import UIKit

final class DragAndDropViewController: UITableViewController {
    
    var images = [#imageLiteral(resourceName: "actor1")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.dropDelegate = self
        tableView.register(ImageTableViewCell.self, forCellReuseIdentifier: "ImageTableViewCell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell", for: indexPath) as! ImageTableViewCell
        cell.mainImageView.image = images[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.width
    }
    
    // MARK: - Actions
    
    @IBAction func barButtonItemAction(_ sender: Any) {
        let imagesViewController = ImagesViewController()
        navigationController?.pushViewController(imagesViewController, animated: true)
    }
}

extension DragAndDropViewController: UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        var destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        }
        else {
            let row = tableView.numberOfRows(inSection: 0)
            destinationIndexPath = IndexPath(row: row, section: 0)
        }
        
        coordinator.session.loadObjects(ofClass: UIImage.self) { images in
            guard let images = images as? [UIImage] else {
                return
            }
            var indexPaths = [IndexPath]()
            for (index, image) in images.enumerated() {
                let indexPath = IndexPath(row: destinationIndexPath.row + index, section: 0)
                self.images.insert(image, at: destinationIndexPath.row)
                indexPaths.append(indexPath)
            }
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
}
