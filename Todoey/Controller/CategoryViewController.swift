//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Jakub Jachowski on 29/08/2019.
//  Copyright © 2019 Jakub Jachowski. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

    var categories: Results<Category>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 100
        loadData()
        tableView.separatorStyle = .none
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let colorHex = categories?.first?.colorHex {
            navigationController?.navigationBar.barTintColor = UIColor(hexString: colorHex)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.backgroundColor = UIColor.init(hexString: categories?[indexPath.row].colorHex ?? "#FFFFFF")
        cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "Pusto :("
        
        return cell
    }

    @IBAction func addCategoryButtonPressed(_ sender: UIBarButtonItem) {
        var alertTextField = UITextField()
        let alert = UIAlertController(title: "Dodaj kategorię", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Nazwa kategorii"
            alertTextField = textField
        }
        
        let action = UIAlertAction(title: "Dodaj", style: .default) { (action) in
            let category = Category()
            if let categoryName = alertTextField.text {
                category.name = categoryName
                category.colorHex = UIColor.randomFlat.hexValue()
                self.tableView.reloadData()
                self.saveData(category: category)
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let index = tableView.indexPathForSelectedRow {
            let destinationVC = segue.destination as! TodoListViewController
            destinationVC.selectedCategory = categories?[index.row]
            self.tableView.deselectRow(at: index, animated: false)
        }
    }
    
    //MARK: - database methods
    
    func loadData() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    func saveData(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("error savig data \(error)")
        }
        tableView.reloadData()
    }
    
    override func deleteSwipe(at indexPath: IndexPath) {
        do {
            try self.realm.write {
                if let category = self.categories?[indexPath.row] {
                    self.realm.delete(category)
                }
            }
        } catch {
            print("error deleting category \(error)")
        }
    }
    
    
}
