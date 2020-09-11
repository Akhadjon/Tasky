//
//  CategoryViewController.swift
//  Tasky
//
//  Created by Akhadjon Abdukhalilov on 9/10/20.
//  Copyright © 2020 Akhadjon Abdukhalilov. All rights reserved.
//

import UIKit
import  CoreData

class CategoryViewController: UIViewController{

    
    private var categories = [Category]()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private let tableView:UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
       setupView()
       loadCategories()
    }
    
   
    @objc func didTapSettingButton(){
        let vc = SettingViewController()
        vc.title = "Setting"
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
       present(navVC, animated: true)
    }
    
    
  //MARK:SetupViews and Constrains
     
    private func setupNavigationBar(){
        navigationItem.title = "Categories"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: "didTapSettingButton")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(didTapAddButton))
    
    }
    
    
    private func setupView(){
           view.backgroundColor = .white
           setupNavigationBar()
           view.addSubview(tableView)
           tableView.delegate = self
           tableView.dataSource = self
           
           NSLayoutConstraint.activate([
               tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
               tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
               tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
               tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
           ])
       }
       
    
    //MARK:Data ManipulationMethods
    func saveCategories(){
        do{
            try context.save()
        }
        catch{
            print("Error saving categories\(error.localizedDescription)")
        }
        tableView.reloadData()
    }
    
    func  loadCategories(){
        let request :NSFetchRequest<Category> = Category.fetchRequest()
        do{
           categories = try context.fetch(request)
        }
        catch{
            print("Error fetching data \(error)")
        }
        tableView.reloadData()
    }
    
    
    //MARK: Add new Categories
    @objc func didTapAddButton(){
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text
            self.categories.append(newCategory)
            self.saveCategories()
        }
        let cancel = UIAlertAction(title: "Cacel", style: .destructive, handler: nil)
        alert.addAction(addAction)
        alert.addAction(cancel)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add new category"
        }
        present(alert,animated: true,completion: nil)
    }
    
    
    
}

extension CategoryViewController:UITableViewDelegate, UITableViewDataSource {
    
    //MARK:TableView datasorce methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.red.cgColor
        return cell
    }
    
     //MARK:TableView Delegate methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let vc = ItemViewController()
        if let indexPath = tableView.indexPathForSelectedRow{
            vc.selectedCategory = categories[indexPath.row]
            vc.navigationItem.title = categories[indexPath.row].name
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        }
       
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
}
