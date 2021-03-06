//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Adithep Pruekpitakpong on 22/12/2561 BE.
//  Copyright © 2561 Adithep Pruekpitakpong. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift
//import SwipeCellKit
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

    let realm = try! Realm()
    
    var categories: Results<Category>?
    
//    var categories = [Category]()
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none
        
        loadCategories()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories?.count ?? 1
//        return categories.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? ""
//        cell.delegate = self
        cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].color ?? "fffff")
        cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
        
        return cell;
    }
    
    
    
    // MARK: - TableView Delegate Methods
    // When a cell has been selected.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        // Remove a highlighted color from the selected row.
//        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        // In case there are multiple segues, it's safe to check its identifier before processing.
        if segue.identifier ?? "" == "goToItems" {
            
            // To be safe, just check if a table view's cell is selected.
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = categories?[indexPath.row]
            }
        }
    }
    
    @IBAction func addButton_Pressed(_ sender: UIBarButtonItem) {
        // It can be accessible in this function.
        var textField = UITextField()
        
        // Setup an alert box.
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        // Set up an "Add" button.
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            // Get access to the text field.
            if (textField.text != nil && textField.text != "") {
                // Add a new item into the item array.
//                let item = Category(context: self.context)
                let category = Category()
                category.name = textField.text!
                category.color = UIColor.randomFlat.hexValue()
//                self.categories.append(category)
                
                // Save data to a persistent storage.
                self.saveCategories(category: category)
                
                // Refresh the table view.
                self.tableView.reloadData()
            }
        }
        
        // Set up a "Cancel" button.
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
            
        }
        
        // Add a text field control into the alert box.
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Category name"
            
            // Set a local text field so that it can be accessible after an "Add" button has been clicked.
            textField = alertTextField
        }
        
        // An "Add" button into the alert box.
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        // Show the alert box.
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Data Storage
    // Save the categories to a persistent storage.
    func saveCategories(category: Category) {
        do {
//            try context.save()
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving categories to context, \(error)")
        }
    }
    // Load the categories from a persistent storage.
    func loadCategories() {
        categories = realm.objects(Category.self)
    }
//    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
//        do {
//            categories = try context.fetch(request)
//        } catch {
//            print("Error fetching categories from context, \(error)")
//        }
//    }
    
    
    // MARK: - Delete Data From Swipe
    override func updateModel(at indexPath: IndexPath) {
        super.updateModel(at: indexPath)
        
        if let category = categories?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(category)
                }

                // Update all rows displayed in the table view.
                //                    tableView.reloadData()
            } catch {
                print("Error deleting a category, \(error)")
            }
        }
    }
}

// MARK: - Search Bar
extension CategoryViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = (searchBar.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        if searchText != "" {
            categories = categories?.filter("name CONTAINS[cd] %@", searchText).sorted(byKeyPath: "name", ascending: true)
        }
        
        tableView.reloadData()
    }
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let searchText = (searchBar.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
//        let request : NSFetchRequest<Category> = Category.fetchRequest()
//        if searchText != "" {
//            request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchText)
//        }
//        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
//
//        loadCategories(with: request)
//        tableView.reloadData()
//    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            // Reload all data.
            loadCategories()
            tableView.reloadData()

            // Hide keyboard.
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
