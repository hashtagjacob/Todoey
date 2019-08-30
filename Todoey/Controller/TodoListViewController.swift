//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Jakub Jachowski on 26/08/2019.
//  Copyright © 2019 Jakub Jachowski. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    let realm = try! Realm() 
    
    var items: Results<Item>?
    var selectedCategory: Category? {
        didSet {
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
        


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = items?[indexPath.row] {
            cell.textLabel?.text = item.name
            cell.accessoryType = item.isDone ? .checkmark : .none
        } else {
            cell.textLabel?.text = "Pusto :("
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let item = items?[indexPath.row] {
            do {
                try realm.write {
                    item.isDone = !item.isDone
                }
           } catch {
               print("error updating item \(error)")
           }
        }
        tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Dodaj nowy element", message: "", preferredStyle: .alert)
        var alertTextfield = UITextField()
        
        let action = UIAlertAction(title: "Dodaj", style: .default) { (action) in
            print("dodaj clicked")
            if let result = alertTextfield.text {
                let item = Item()
                item.name = result
//                item.parentCategory = LinkingObjects(fromType: Category.self, property: <#T##String#>)
                
                self.tableView.reloadData()
                
                self.saveData(item: item)
            }
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Podaj nazwę elementu"
            alertTextfield = textField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func saveData(item: Item) {
        do {
            try realm.write {
                selectedCategory?.items.append(item)
                tableView.reloadData()
            }
        } catch {
            print("error appending item \(error)")
        }
    }
    
    func loadData() {
        items = selectedCategory?.items.sorted(byKeyPath: "timeCreated", ascending: true)
        tableView.reloadData()
    }
    
}
//MARK: - search bar
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchByValue = searchBar.text {
            let predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchByValue)
            
            items = items?.filter(predicate).sorted(byKeyPath: "name", ascending: true)
            tableView.reloadData()
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
