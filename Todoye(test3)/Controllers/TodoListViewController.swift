//
//  ViewController.swift
//  Todoey(test2)
//
//  Created by Nurqalam on 28.01.2022.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var listArray = [Item]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Hello")

        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadItems()

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = listArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.textLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        context.delete(listArray[indexPath.row])
//        listArray.remove(at: indexPath.row)
//
        listArray[indexPath.row].done = !listArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textF = UITextField()
        
        let alert = UIAlertController(title: "Add new Item", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if let text = textF.text {
                
                let newItem = Item(context: self.context)
                newItem.title = text
                newItem.done = false
                
                self.listArray.append(newItem)
                
                self.saveItems()
            }
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        alert.addTextField { (textField) in
            textField.placeholder = "Create new Item"
            textF = textField
        }
        
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("error contexting \(error)")
        }
        
        
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {

        do {
            listArray = try context.fetch(request)
        } catch {
            print("error fetching cotext \(error)")
        }
        tableView.reloadData()
    }
    
}

//MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
       
        loadItems(with: request)

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
