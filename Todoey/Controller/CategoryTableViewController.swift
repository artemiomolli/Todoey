//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Артём Гуральник on 2/5/18.
//  Copyright © 2018 Артём Гуральник. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
  
            let newItem = Category(context: self.context)
            
            newItem.name = textField.text!
            
            self.categories.append(newItem)
            
            self.saveData()
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
        
        let item = categories[indexPath.row]
        cell.textLabel?.text = item.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

     //MARK - Manipulation
    
    func saveData() {
        
        do {
            
            try context.save()
        } catch {
            
            print(error)
        }
        
        self.tableView.reloadData()
    }
    
    func loadData() {
       
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            
            categories = try context.fetch(fetchRequest)
        }catch {
            
            print(error)
        }
        
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destonationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destonationVC.selectedCategory = categories[indexPath.row]
        }
    }
}
