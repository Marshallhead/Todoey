//
//  ViewController.swift
//  Todoey
//
//  Created by Macbook on 22/11/2019.
//  Copyright © 2019 Marshall Lawal. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = ["find mike", "buy eggos", "destroy demogorgon"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK - Tableview Dtasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count // displays rows based on ammount in array
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)//reusable cell
        
        cell.textLabel?.text = itemArray[indexPath.row]//populated with text
        
        return cell
    }
    // MARK - Tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
//MARK - ADD New Items

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will hapen when the user clicks the "add item" button
            self.itemArray.append(textField.text!)// apending/adding new item to initial array
            
            self.tableView.reloadData()// reloads rows in the section for new inputs
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField// created a var textfield to be equall to alert textfield to make it a global instead of local variable
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}


