//
//  CategoryViewController.swift
//  Todoye(test3)
//
//  Created by Nurqalam on 30.01.2022.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryList = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadCat()
    }


    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        let catItem = categoryList[indexPath.row]
        cell.textLabel?.text = catItem.name
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
            destionationVC.selectedCategory = categoryList[indexPath.row]
        }
    }
    
    
    
    @IBAction func addButtPressed(_ sender: UIBarButtonItem) {
        var textF = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            
            if let text = textF.text {
                let newCat = Category(context: self.context)
                newCat.name = text
                self.categoryList.append(newCat)
                
                self.saveCat()
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
    
    func saveCat() {
        do {
            try context.save()
        } catch {
            print("error saving context \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCat(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryList = try context.fetch(request)
        } catch {
            print("Error fetching \(error)")
        }
        tableView.reloadData()
    }
    
}
