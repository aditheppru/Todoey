//
//  ViewController.swift
//  Todoey
//
//  Created by Adithep Pruekpitakpong on 20/12/2561 BE.
//  Copyright © 2561 Adithep Pruekpitakpong. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    let keyTodoListArray = "TodoListArray"
    
    var itemArray = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

//        print(dataFilePath!)
//        
//        for item in 1...10 {
//            itemArray.append(Item(itemTitle: "Item\(item)", isItemDone: false))
//        }
        
        loadItems()
    }

    
    //MARK - Tableview Datasource Methods
    // Display rows.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        cell.accessoryType = itemArray[indexPath.row].isDone ? .checkmark : .none
        
        return cell;
    }
    
    //MARK - TableView Delegate Methods
    // When a cell has been selected.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Change a selected row to deselected one and a deselected row to a selected one.
        itemArray[indexPath.row].isDone = !itemArray[indexPath.row].isDone
        
        // Save data to a persistent storage.
        saveItems()
        
        // Update all rows displayed in the table view.
        tableView.reloadData()
        
        // Remove a highlighted color from the selected row.
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButton_Pressed(_ sender: UIBarButtonItem) {
        // It can be accessible in this function.
        var textField = UITextField()
        
        // Setup an alert box.
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        // Set up an "Add Item" button.
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // Get access to the text field.
            if (textField.text != nil && textField.text != "") {
                // Add a new item into the item array.
                self.itemArray.append(Item(itemTitle: textField.text!, isItemDone: false))
                
                // Save data to a persistent storage.
                self.saveItems()
                
                // Refresh the table view.
                self.tableView.reloadData()
            }
        }
        
        // Add a text field control into the alert box.
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            
            // Set a local text field so that it can be accessible after an "Add Item" button has been clicked.
            textField = alertTextField
        }
        
        // An "Add Item" button into the alert box.
        alert.addAction(action)
        
        // Show the alert box.
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - Data Storage
    // Save the item array to a persistent storage.
    func saveItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
    }
    // Load the item array from a persistent storage.
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array, \(error)")
            }
        }
    }
}

