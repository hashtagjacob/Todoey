//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Jakub Jachowski on 30/08/2019.
//  Copyright © 2019 Jakub Jachowski. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.deleteSwipe(at: indexPath)
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "trash")
        deleteAction.title = "Usuń"
        deleteAction.textColor = .black
        
        return [deleteAction]
    }
    
    func deleteSwipe(at indexPath: IndexPath) {
        //delete at index
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
