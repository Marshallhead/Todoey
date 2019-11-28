//
//  ViewController.swift
//  Todoey
//
//  Created by Macbook on 22/11/2019.
//  Copyright © 2019 Marshall Lawal. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    //  var itemArray = ["find mike", "buy eggos", "destroy demogorgon"]// hard coded, need a way to persist new data
    var itemArray = [Item]()// inheriting from items properties(title and done/checkmark) in data model
    
    let defaults = UserDefaults.standard // userdefaults used to persist small ammount of data. this is a P.LIST created by apple and cannot be modified heavily. for custom p.list use NScoder/core/realm
    //Item.plist is the custom plist and is customisable as per the item data model with a title and done property, userdefaults.plist will be a dictionary and  no customs
    
  //  let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")searchpath directory is the document directory like docs folder on desktop, location is in the users domain mask so like pc user(admin) location where all info of this app is stored. appending path is adding a plist to the doc we just created
    //NSCODER CODE
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // grabbing the object from a class we could have simply said Appdeletgate.persistentcontainer.context, but instead we use the share.uiapp when the phone is running and set it as app delegate first. THE "C" in CRUD creating the context that grabs persistent container and grab a reference to the context in that persistent container
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        //
        //        let newItem = Item()
        //        newItem.title = "Find Mike"
        //        itemArray.append(newItem)
        //
        //        let newItem2 = Item()
        //        newItem2.title = "Buy Eggos"
        //        itemArray.append(newItem2)
        //
        //        let newItem3 = Item()
        //        newItem3.title = "Destroy Demorgogon"
        //        itemArray.append(newItem3)
        
        loadItems()
        
        //        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {// use if let cos app crases if appended array is empty
        //            itemArray = items// populate item array upon app opening
        //        }(NSDefaults code)
    }
    
    //MARK - Tableview Dtasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count // displays rows based on ammount in array
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)//reusable cell gets reinitialized when we scroll screen, PROMBLEM is it carries with it its properties like a checkmark. to solve, assign the checkmark with the data not the cell. create a datamodel
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title//populated with text
        
        // Tenary operator ==>
        //value = condition? valueIfTrue : valaueIfFalse
        
        cell.accessoryType = item.done ? .checkmark : .none
        //
        //        if item.done == true {// if row is selected.done, add checkmark acessory
        //            cell.accessoryType = .checkmark
        //        } else {
        //            cell.accessoryType = .none
        //        }
        return cell
    }
    // MARK - Tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print(itemArray[indexPath.row])
        
      /*  context.delete(itemArray[indexPath.row])//deleteing here is just deleting data in temp area, this should ve saved and it gets commited to the persistent container using saveitems() below. context.delete should be called first otherwise index will be out of range
        
        itemArray.remove(at: indexPath.row)//updates tem array and leaves it blank, but the previous data is still in the SQLite container in the backend. THE "D" IN CRUD*/ 
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done //if selected item has no checkmark..THE "U" in CRUD
        saveItems()//done property saved in plist upon toggling checkmark
        
        //        if itemArray[indexPath.row].done == false { //if selected item has no checkmark
        //            itemArray[indexPath.row].done = true// then put the checkmark
        //        } else {
        //            itemArray[indexPath.row].done = false//otherwise remove checkmark
        //        }
        
        //        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        //
        //        } else {
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        //        }
        tableView.reloadData()// forces table view to call its delegate method and reload data inside, letting checkmark show
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    //MARK - ADD New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will hapen when the user clicks the "add item" button
            
            
            let newItem = Item(context: self.context)
            //  let newItem = Item()...CODE FOR NSCODER
            newItem.title = textField.text!
            newItem.done = false//needed in  to give it a value cos we set our title and done in coredata model as not optional so we need
            
            self.itemArray.append(newItem)// apending/adding new item to initial array
            
            
            // self.defaults.set(self.itemArray, forKey: "ToDoListArray")// saving the new apended item to user defaults
            //user defaults are saved in p.list, needs key value pairs
            // to persist the data back to the app from user defaults, we need the filepath of the app sandbox, ID of simulator and sandbox
            //retrieve data in viewDidLoad
            //CODE FOR USER DEFAULTS
            
            // self.tableView.reloadData()// reloads rows in the section for new inputs
            self.saveItems()// this aloows items added to the table to be saved in the plist
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField// created a var textfield to be equall to alert textfield to make it a global instead of local variable
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    //MARK: - Model Mnipulation method
    func saveItems() {
        //        let encoder = PropertyListEncoder()// Using encoder instead of user default below. this encoder will encoder our array into the custom p.list just created
        //        do{
        //            let data = try encoder.encode(itemArray)//set data as itemarray then encoding the item array into the p.list
        //            try data.write(to: dataFilePath!)//put the data/item array into the filepath
        //
        //        }catch {
        //            print("Error encoding item array, \(error)")
        //        }
        //        self.tableView.reloadData()
        //    } NSCODER CODE
        
        
        do{
            try context.save()
            // context is where you CRUD,Create, read, update and destroy befor saving it to the persistent container
        }catch {
            print("Error saving context, \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems() {
//        if let data = try? Data(contentsOf: dataFilePath!) {
//            let decoder = PropertyListDecoder()
//            do {
//                itemArray = try decoder.decode([Item].self, from: data)
//            }catch {
//                print("Error decoding item array, \(error)")
//
//            }
//        }NSCODER CODE
        //THE "R" in CRUD
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        //need to specify data type, array of items
        do {
           itemArray = try context.fetch(request)
        }catch {
            print("Error fetching data from context, \(error)")

        }
    }
}
