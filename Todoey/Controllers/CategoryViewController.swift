//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Hendrik Hendrik on 18/8/18.
//  Copyright © 2018 Hendrik Hendrik. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift

class CategoryViewController: UITableViewController {

    var categories : Results<Category>?
    //For Core Data
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //Realm
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (alert) in
            //CoreData
            /* let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categories.append(newCategory)
            self.saveCategories() */
            
            //Realm
            let newCategory = Category()
            newCategory.name = textField.text!
            //self.categories.append(newCategory)
            self.save(category: newCategory)
        }
        
        alert.addAction(action)
        alert.addTextField { (uiTextField) in
            uiTextField.placeholder = "Create a new category"
            textField = uiTextField
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - TableView DataSource method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
        //return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
        
        return cell
    }
    
    //MARK - data manipulation Core Data
    /* func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving content\(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            try categories = context.fetch(request)
        } catch {
            print("Error loading content\(error)")
        }
        
    } */
    
    //MARK - data manipulation realm
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
            print("Saved")
        } catch {
            print("Error saving to realm \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    //MARK - TableView Delegate method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
}
