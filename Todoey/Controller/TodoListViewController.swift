//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Jakub Jachowski on 26/08/2019.
//  Copyright © 2019 Jakub Jachowski. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    var itemArrayBeforeSearch = [Item]()
    var selectedCategory: Category? {
        didSet {
            loadData()
            
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].text
        cell.accessoryType = itemArray[indexPath.row].isChecked ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            itemArray[indexPath.row].isChecked = false
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            itemArray[indexPath.row].isChecked = true
        }
        
        saveData()
    }

   
    fileprivate func saveData() {
        do {
            try context.save()
        } catch {
            print("error!!! \(error)")
        }
    }
    
    func loadData(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        var predicateArray = [NSPredicate]()
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        predicateArray.append(categoryPredicate)
        
        if let requestPredicate = request.predicate {
            predicateArray.append(requestPredicate)
        }
        
        let compondPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicateArray)
        request.predicate = compondPredicate
        
        
        do {
            itemArray =  try context.fetch(request)
            tableView.reloadData()
        } catch {
            print("Error fetching data \(error)")
        }
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Dodaj nowy element", message: "", preferredStyle: .alert)
        var alertTextfield = UITextField()
        
        let action = UIAlertAction(title: "Dodaj", style: .default) { (action) in
            print("dodaj clicked")
            if let result = alertTextfield.text {
                let item = Item(context: self.context)
                item.text = result
                item.parentCategory = self.selectedCategory
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
//MARK: - search bar
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchByValue = searchBar.text {
            let request: NSFetchRequest<Item> = Item.fetchRequest()
            let predicate = NSPredicate(format: "text CONTAINS[cd] %@", searchByValue)
            let sortDescriptor = NSSortDescriptor(key: "text", ascending: true)
            
            request.predicate = predicate
            request.sortDescriptors = [sortDescriptor]
            
            itemArrayBeforeSearch = itemArray
            loadData(with: request)
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
