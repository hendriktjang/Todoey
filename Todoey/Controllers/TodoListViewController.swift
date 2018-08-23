//
//  ViewController.swift
//  Todoey
//
//  Created by Hendrik Hendrik on 11/8/18.
//  Copyright © 2018 Hendrik Hendrik. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift

class TodoListViewController: UITableViewController {
    
    //var itemArray = ["Todo1", "Todo2", "Todo3"]
    var toDoItems: Results<Item>?
    
    let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    //For Core Data
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //Realm
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("DataFilePath : \(dataFilePath!)")
        
        
    }

    //MARK - Tableview Data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
    
        if let item = toDoItems?[indexPath.row] {
        
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added yet"
        }
        return cell
    }
    
    //MARK - Tableview delegate method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        //Core Data Update
        //toDoItems[indexPath.row].done = !toDoItems[indexPath.row].done
        //saveItems()
        
        //Realm Update
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write{
                    item.done = !item.done
                }
            } catch {
                print("error updating item\(error)")
            }
        }
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField: UITextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (alert) in
            //What will happen when user clicks Add Item
            
            //Core Data
            /*
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            //save to Items.plist
            self.saveItems() */
            
            //Realm
            if let currentCategory = self.selectedCategory {
                let newItem = Item()
                newItem.title = textField.text!
                newItem.done = false
                newItem.dateCreated = Date()
                do {
                    try self.realm.write {
                        //Note this:
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving item \(error)")
                }
            }
            self.tableView.reloadData()
            
        }
        
        alert.addAction(action)
        alert.addTextField { (uiTextField) in
            uiTextField.placeholder = "Create a new item"
            textField = uiTextField
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - coreData Data Manipulation
//    func saveItems() {
//        //Using encodable
//        /* let encoder = PropertyListEncoder()
//        do {
//            let data = try encoder.encode(itemArray)
//            try data.write(to: dataFilePath!)
//        } catch {
//            print("Error while encoding \(error)")
//        } */
//
//        do {
//            try context.save()
//        } catch {
//            print("Error saving context \(error)")
//        }
//        tableView.reloadData()
//
//    }
//
//    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
//        //Using encodable
//        /* if let data = try? Data(contentsOf: dataFilePath!) { //optional binding
//            let decoder = PropertyListDecoder()
//            do {
//                //Note the special .self here to let swift know the data type!
//                itemArray = try decoder.decode([Item].self, from: data)
//            } catch {
//                print("Error in decoding: \(error)")
//            }
//        } */
//
//        //Using coredata
//        //let request: NSFetchRequest<Item> = Item.fetchRequest()
//
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//        if let additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//        } else {
//            request.predicate = categoryPredicate
//        }
//
//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print("Error reading context \(error)")
//        }
//        tableView.reloadData()
//    }
    
        //MARK - data manipulation Realm
    func loadItems() {
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
    }
}

//MARK: - Search bar methods
extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //For Core data
        /* let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]

        loadItems(with: request, predicate: predicate) */

        //For Realm
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        /* if searchBar.text!.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } */
    }
}

