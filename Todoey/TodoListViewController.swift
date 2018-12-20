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
    
    var itemArray: [String] = []
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Check null before setting an array to a class variable
        if let items = defaults.array(forKey: keyTodoListArray) as? [String] {
            itemArray = items
        }
    }

    
    //MARK - Tableview Datasource Methods
    // Display rows.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell;
    }
    
    //MARK - TableView Delegate Methods
    // When a cell has been selected.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Display or remove a checkmark sign.
        if (tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark) {
            // Clear a checkmark
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            // Display a checkmark.
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        // Remove a highlighted color from the selected row.
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
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
                self.itemArray.append(textField.text!)
                
                self.defaults.set(self.itemArray, forKey: self.keyTodoListArray)
                
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
}

