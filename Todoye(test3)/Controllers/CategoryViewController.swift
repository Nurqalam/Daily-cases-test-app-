//
//  CategoryViewController.swift
//  Todoye(test3)
//
//  Created by Nurqalam on 30.01.2022.
//

import UIKit
import RealmSwift



class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categoryList: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
                
        loadCat()
        
    }


    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let catItem = categoryList?[indexPath.row]
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = catItem?.name ?? "No categories yet"
        cell.textLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        return cell
    }
    
    
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destionationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destionationVC.selectedCategory = categoryList?[indexPath.row]
        }
    }
    
    
    
    @IBAction func addButtPressed(_ sender: UIBarButtonItem) {
        var textF = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            
            if let text = textF.text {
                let newCat = Category()
                newCat.name = text
                
                self.saveCat(category: newCat)
            }
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        alert.addTextField { (textField) in
            textField.placeholder = "Type new Category name..."
            textF = textField
        }
        
        present(alert, animated: true, completion: nil)  
        
    }
    
    
    
    //MARK: - Data Manipulation Methods
    
    func saveCat(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("error saving context \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCat() {
        categoryList = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        
        super.updateModel(at: indexPath)
       
        if let catForDel = self.categoryList?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(catForDel)
                }
            } catch {
                print("Error deleting \(error)")
            }
        }
    }
    
    
}
