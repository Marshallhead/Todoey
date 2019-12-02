//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Macbook on 28/11/2019.
//  Copyright © 2019 Marshall Lawal. All rights reserved.
//
/* BEFORE MAKING THIS FILE, DO THE FOLLOWING// FOR REALM
 - add new table viewcontroller, and make it rootview controller(yellow button on navigation controller with control to reootview controller) , "show"seque new root view controller to todolistview controller-set Identifier "gotoitems"
 -create this/new cocoa touch file and subclass of UITableview controller. link this categoryView controller to new rootview controller. give prototype cell an identifier "categorycell"
 - create barbutton item and chnage it to "ADD" to make it a plus sign, chnage tint to white. link it to swift file as an IBAction. select navigation bar(blue color) and change its title to "Todey", chnage for the TodoListViewController to "Items"
 - go into Datamodel file, view in graph view, click "ADD ENTITY" click "add attribute(plus button below) and name it to "name", uncheck optional and set attribute type to "String"
 - create relationship between the two graph with control "drag", renew relationship to "items", change type to "many", rename the inverse as "parent category" and type is "to oe"


 */
//MARK: - CORE DATA CATEGORYVC
import UIKit
import CoreData
import RealmSwift

class CategoryViewController: UITableViewController {
        
    var categories = [Category]()// needed becos when we quary realm database(loadcategories), results returned is in form Results type
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

    
    }

    //MARK: - TableView Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count // displays rows based on ammount in array. if categories.count is not nil, return categories but if it is then return 1 row(nil coalescing operator)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)//reusable cell gets reinitialized when we scroll screen, PROMBLEM is it carries with it its properties like a checkmark. to solve, assign the checkmark with the data not the cell. create a datamodel
        
        cell.textLabel?.text = categories[indexPath.row].name //populated with text

        return cell
    }
    
    
    //MARK: - TableView Delegate Mthods
    // what should happen when we click inside the cells inside the category tableview
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController// takes you from categories to todo list
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories[indexPath.row]
        }// identifies selected row
    }
    
    //MARK: - Data Manipulation Methods
    func saveCategories() {
        do{
            try context.save()
            
            }catch {
                print("Error saving category, \(error)")
            }
            self.tableView.reloadData()
        }
    
    func loadCategories() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do {
     categories = try context.fetch(request)
        } catch {
            print("Error loading categores \(error)")
        }
        tableView.reloadData()
    }
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
       
        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Add", style: .default) { (action) in
                // what will hapen when the user clicks the "add item" button
                
                
                let newCategory = Category(context: self.context)
                newCategory.name = textField.text!
                
                self.categories.append(newCategory)
              
                self.saveCategories()// this aloows items added to the table to be saved in the plist
            }
            alert.addTextField { (field) in
                textField.placeholder = "Create new category"
                textField = field// created a var textfield to be equall to alert textfield to make it a global instead of local variable
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
}
    





//MARK: - REAL CATEGORYVC
/*
import UIKit
import CoreData
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()// initialize new acesspoint to realm
    
    var categories: Results<Category>?// needed becos when we quary realm database(loadcategories), results returned is in form Results type


    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

    
    }

    //MARK: - TableView Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1 // displays rows based on ammount in array. if categories.count is not nil, return categories but if it is then return 1 row(nil coalescing operator)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)//reusable cell gets reinitialized when we scroll screen, PROMBLEM is it carries with it its properties like a checkmark. to solve, assign the checkmark with the data not the cell. create a datamodel
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"//populated with text

        return cell
    }
    
    
    //MARK: - TableView Delegate Mthods
    // what should happen when we click inside the cells inside the category tableview
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController// takes you from categories to todo list
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
        }// identifies selected row
    }
    
    //MARK: - Data Manipulation Methods
    func save(category: Category) {
        do{
            try realm.write {// comit changes to realm by adding new categories
                realm.add(category)
            }
            }catch {
                print("Error saving category, \(error)")
            }
            self.tableView.reloadData()
        }
    
    func loadCategories() {
         categories = realm.objects(Category.self)// categories looks inside the realm and fetch all objects that belong to category data type., load upon viewdidload
        
             tableView.reloadData()//
         }
    
    
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
       
        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Add", style: .default) { (action) in
                // what will hapen when the user clicks the "add item" button
                
                
                let newCategory = Category()//((context: self.context))--in core data
                newCategory.name = textField.text!
                //needed in  to give it a value cos we set our name in coredata model as not optional so we need
                
              
                self.save(category: newCategory)// this aloows items added to the table to be saved in the plist
            }
            alert.addTextField { (field) in
                textField.placeholder = "Create new category"
                textField = field// created a var textfield to be equall to alert textfield to make it a global instead of local variable
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }

    
    

*/
