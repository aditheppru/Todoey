//
//  ViewController.swift
//  Todoey
//
//  Created by Adithep Pruekpitakpong on 20/12/2561 BE.
//  Copyright © 2561 Adithep Pruekpitakpong. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift

class TodoListViewController: UITableViewController {

    let realm = try! Realm()
    var items: Results<Item>?
    
//    let keyTodoListArray = "TodoListArray"
    
    // All code in didSet block will be executed when selectedCategory has a value.
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
//    var items = [Item]()

//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // For storing custom models as codable
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
//        print(dataFilePath!)
//        
//        for item in 1...10 {
//            itemArray.append(Item(itemTitle: "Item\(item)", isItemDone: false))
//        }
    }

    
    //MARK: - Tableview Datasource Methods
    // Display rows.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = items?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.isDone ? .checkmark : .none
        } else {
            cell.textLabel?.text = ""
            cell.accessoryType = .none
        }
        
        return cell;
    }
    
    // MARK: - TableView Delegate Methods
    // When a cell has been selected.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Change a selected row to deselected one and a deselected row to a selected one.
//        items[indexPath.row].isDone = !items[indexPath.row].isDone
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        // Save data to a persistent storage.
//        saveItems()
        
        if let item = items?[indexPath.row] {
            do {
                try realm.write {
//                    realm.delete(item)
                    item.isDone = !item.isDone
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        // Update all rows displayed in the table view.
        tableView.reloadData()
        
        // Remove a highlighted color from the selected row.
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButton_Pressed(_ sender: UIBarButtonItem) {
        // It can be accessible in this function.
        var textField = UITextField()
        
        // Setup an alert box.
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        // Set up an "Add" button.
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            // Get access to the text field.
            if (textField.text != nil && textField.text != "") {
                // Add a new item into the items.
//                let item = Item(context: self.context)
                
                if self.selectedCategory != nil {
                    do {
                        try self.realm.write {
                            let item = Item()
                            item.title = textField.text!
                            item.isDone = false
                            item.dateCreated = Date()
                            self.selectedCategory?.items.append(item)
                        }
                    } catch {
                        print("Error saving new items, \(error)")
                    }
                }
                
//                item.parentCategory = self.selectedCategory
//                self.items.append(item)
//                self.itemArray.append(Item(itemTitle: textField.text!, isItemDone: false))
                
                // Save data to a persistent storage.
//                self.saveItems()
                
                // Refresh the table view.
                self.tableView.reloadData()
            }
        }
        
        // Set up a "Cancel" button.
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
            
        }
        
        // Add a text field control into the alert box.
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Item name"
            
            // Set a local text field so that it can be accessible after an "Add" button has been clicked.
            textField = alertTextField
        }
        
        // An "Add Item" button into the alert box.
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        // Show the alert box.
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Data Storage
    // Save the items to a persistent storage.
//    func saveItems() {
//        do {
//            try context.save()
//        } catch {
//            print("Error saving items to context, \(error)")
//        }
//
////        let encoder = PropertyListEncoder()
////        do {
////            let data = try encoder.encode(itemArray)
////            try data.write(to: dataFilePath!)
////        } catch {
////            print("Error encoding item array, \(error)")
////        }
//    }
    // Load the items from a persistent storage.
    func loadItems() {
        items = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: false)
    }
//    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()
//        , predicate: NSPredicate? = nil) {
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//        // Create a new array of predicates and add a category predicate as default.
//        var predicates = [categoryPredicate]
//
//        // Append an additional predicate when it's not nil.
//        if let additionalPredicate = predicate {
//            predicates.append(additionalPredicate)
//        }
//
//        // Compound all predicates.
//        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
//
//        do {
//            items = try context.fetch(request)
//        } catch {
//            print("Error fetching items from context \(error)")
//        }
//
////        if let data = try? Data(contentsOf: dataFilePath!) {
////            let decoder = PropertyListDecoder()
////            do {
////                itemArray = try decoder.decode([Item].self, from: data)
////            } catch {
////                print("Error decoding item array, \(error)")
////            }
////        }
//    }

}

// MARK: - Search Bar
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = (searchBar.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        if searchText != "" {
            items = items?.filter("title CONTAINS[cd] %@", searchText).sorted(byKeyPath: "dateCreated", ascending: false)
        }
        
        tableView.reloadData()
    }
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let searchText = (searchBar.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//        var itemPredicate: NSPredicate?
//        if searchText != "" {
//            itemPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
//        }
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request, predicate: itemPredicate)
//        tableView.reloadData()
//    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            // Reload all data.
            loadItems()
            tableView.reloadData()
            
            // Hide keyboard.
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
