//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Jakub Jachowski on 26/08/2019.
//  Copyright © 2019 Jakub Jachowski. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [ListItem]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        }
        


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].itemText
        cell.accessoryType = itemArray[indexPath.row].isSelected ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            itemArray[indexPath.row].isSelected = false
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            itemArray[indexPath.row].isSelected = true
        }
        
        saveData()
    }

   
    fileprivate func saveData() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("error!!! \(error)")
        }
    }
    
    func loadData() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([ListItem].self, from: data)
            } catch {
                print(error)
            }
            
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Dodaj nowy element", message: "", preferredStyle: .alert)
        var alertTextfield = UITextField()
        
        let action = UIAlertAction(title: "Dodaj", style: .default) { (action) in
            print("dodaj clicked")
            if let result = alertTextfield.text {
                let item = ListItem(text: result)
                self.itemArray.append(item)
                self.tableView.reloadData()
                
                self.saveData()
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
