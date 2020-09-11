//
//  ItemViewController.swift
//  Tasky
//
//  Created by Akhadjon Abdukhalilov on 9/11/20.
//  Copyright © 2020 Akhadjon Abdukhalilov. All rights reserved.
//

import UIKit
import CoreData

class ItemViewController: UIViewController {

    private var items = [Item]()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    
    private let tableView:UITableView = {
           let tableView = UITableView()
           tableView.translatesAutoresizingMaskIntoConstraints = false
           tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
           return tableView
    }()
    
    private let searchBar:UISearchBar={
        let searchBar = UISearchBar()
        searchBar.frame = CGRect(x: 0, y: 0, width: 200, height: 70)
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = " Search Here....."
        searchBar.sizeToFit()
        return searchBar
    }()
    
//    init(with category:Category?){
//        self.caategory = category
//        super.init(nibName: nil, bundle: nil)
//
//        loadItems()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
    var selectedCategory:Category?{
        didSet{
           loadItems()
        }
    }
       
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    
//MARK:SetupViews and Constrains
    private func setupNavigationBar(){
        navigationItem.title = selectedCategory?.name
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(didTapAddButton))
        
    }
    private func setupView(){
        view.backgroundColor = .white
        setupNavigationBar()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = searchBar
        searchBar.delegate = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    
//MARK: Add New Item
    @objc func didTapAddButton(){
      var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            let newItem = Item(context:self.context)
            newItem.title = textField.text
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.items.append(newItem)
            print(self.items)
            self.saveItems()
        }
        let cancel = UIAlertAction(title: "Cacel", style: .destructive, handler: nil)
        alert.addAction(addAction)
        alert.addAction(cancel)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add new Item"
        }
        present(alert,animated: true,completion: nil)
        
    }
    
//MARK: Data Manipulation methods
    func saveItems(){
        do{
            try context.save()
        }
        catch{
            print("Error saving categories\(error.localizedDescription)")
        }
        tableView.reloadData()
    }
    
    func loadItems(with request:NSFetchRequest<Item> = Item.fetchRequest(), predicate:NSPredicate? = nil){
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@",selectedCategory?.name! as! CVarArg )

        if let additionalPrdicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPrdicate])
        }else{
            request.predicate = categoryPredicate
        }
        
       
        do{
           items = try context.fetch(request)
        }
        catch{
            print("Error fetching data \(error)")
        }
        tableView.reloadData()
    }
    
    
    

}

extension ItemViewController:UITableViewDataSource,UITableViewDelegate{
    
//MARK: TableView data Source Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row].title
        cell.accessoryType = items[indexPath.row].done ? .checkmark:.none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        items[indexPath.row].done = !items[indexPath.row].done
        saveItems()
    }
    
}

//MARK:SearchBar Delegate Methods
extension ItemViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request:NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@",searchBar.text!)
        request.sortDescriptors = [ NSSortDescriptor(key: "title", ascending:true)]
        loadItems(with: request,predicate:predicate)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
