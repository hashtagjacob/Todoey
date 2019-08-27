//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Jakub Jachowski on 26/08/2019.
//  Copyright © 2019 Jakub Jachowski. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = ["Do weird shit", "Fuck bitches", "Get paid"]
    var userDefaults = UserDefaults()
    override func viewDidLoad() {
        super.viewDidLoad()
        if let array = userDefaults.value(forKey: "itemArray") {
            itemArray = array as! [String]
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
    }

   
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Dodaj nowy element", message: "", preferredStyle: .alert)
        var alertTextfield = UITextField()
        
        let action = UIAlertAction(title: "Dodaj", style: .default) { (action) in
            print("dodaj clicked")
            if let result = alertTextfield.text {
                self.itemArray.append(result)
                self.tableView.reloadData()
                self.userDefaults.set(self.itemArray, forKey: "itemArray")
            }
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Podaj nazwę elementu"
            alertTextfield = textField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    
}
