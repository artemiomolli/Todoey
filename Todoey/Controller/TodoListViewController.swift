//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Артём Гуральник on 2/3/18.
//  Copyright © 2018 Артём Гуральник. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    var toDoItems: Results<Item>?
    let realm = try! Realm()
    var selectedCategory: Category? {
        
        didSet{
            
            loadData()
        }
    }
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
   
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    //MARK - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
        
            cell.accessoryType = item.done ? .checkmark : .none
        }else {
            
            cell.textLabel?.text = "No Items"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let item = toDoItems?[indexPath.row] {
            
            do {
                
                try realm.write {
       
                    item.done = !item.done
                }
            }catch {
                
                print(error)
            }
        }

        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
      //MARK - Actions
    
    @IBAction func addActionPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()

        let alert = UIAlertController(title: "Add new Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currCat = self.selectedCategory {

                do {
                    
                    try self.realm.write {
                        
                        let newItem = Item()
                        newItem.title = textField.text!
                        currCat.items.append(newItem)
                    }
                } catch {
                    
                    print(error)
                }
            }
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - Model Manipulations

    
    func loadData() {

        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
}

extension TodoListViewController: UISearchBarDelegate {
    
    //MARK -  UISearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        toDoItems = toDoItems?.filter(predicate).sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            
            loadData()
            
            DispatchQueue.main.async {
                
                searchBar.resignFirstResponder()
            }
        }
    }
}
