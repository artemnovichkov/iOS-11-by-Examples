//
//  ImagesViewController.swift
//  iOS-11-by-Examples
//
//  Created by Artem Novichkov on 11/07/2017.
//  Copyright © 2017 Artem Novichkov. All rights reserved.
//

import UIKit

final class ImagesViewController: UITableViewController {
    
    let images = [#imageLiteral(resourceName: "actor1"), #imageLiteral(resourceName: "actor2"), #imageLiteral(resourceName: "actor3"), #imageLiteral(resourceName: "actor4"), #imageLiteral(resourceName: "actor5"), #imageLiteral(resourceName: "actor6"), #imageLiteral(resourceName: "actor7")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.dragDelegate = self
        tableView.dragInteractionEnabled = true
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
}

extension ImagesViewController: UITableViewDragDelegate {
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let image = images[indexPath.row]
        let itemProvider = NSItemProvider(object: image)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = image
        return [dragItem]
    }
    
    func tableView(_ tableView: UITableView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        let image = images[indexPath.row]
        let itemProvider = NSItemProvider(object: image)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = image
        return [dragItem]
    }
}
