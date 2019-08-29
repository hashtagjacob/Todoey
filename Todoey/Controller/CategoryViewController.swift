//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Jakub Jachowski on 29/08/2019.
//  Copyright © 2019 Jakub Jachowski. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = categories[indexPath.row].name
        
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
            let category = Category(context: self.context)
            category.name = alertTextField.text
            self.categories.append(category)
            self.tableView.reloadData()
        }
        saveData()
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
            destinationVC.selectedCategory = categories[index.row]
        }
    }
    
    //MARK: - database methods
    
    func loadData(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categories = try context.fetch(request)
        } catch {
            print("error fetching data \(error)")
        }
    }
    
    func saveData() {
        do {
            try context.save()
        } catch {
            print("error savig data \(error)")
        }
    }
    
    
}