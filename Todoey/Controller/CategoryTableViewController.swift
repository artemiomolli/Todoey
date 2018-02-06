//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Артём Гуральник on 2/5/18.
//  Copyright © 2018 Артём Гуральник. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {

    let realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
  
            let newItem = Category()
            newItem.name = textField.text!
            
            self.saveData(category: newItem)
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
     //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let item = categories?[indexPath.row]
        cell.textLabel?.text = item?.name ?? "No categories"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

     //MARK - Manipulation
    
    func saveData(category: Category) {
        
        do {
            
            try realm.write {
                
                realm.add(category)
            }
        } catch {
            
            print(error)
        }
        
        self.tableView.reloadData()
    }
    
    func loadData() {

        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    //MARK - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destonationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destonationVC.selectedCategory = categories?[indexPath.row]
        }
    }
}
