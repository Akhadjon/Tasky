//
//  ViewController.swift
//  Tasky
//
//  Created by Akhadjon Abdukhalilov on 9/9/20.
//  Copyright © 2020 Akhadjon Abdukhalilov. All rights reserved.
//

import UIKit
import CoreData

class HomeVC: UIViewController {

    var data = [Task]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private let tableView:UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    

    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()


         loadData()
    
    }
    
    
    
    private func setupView(){
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        setupNavigationbar()
    }
    
    private func setupNavigationbar(){
        navigationItem.title = "Task"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.rectangle.on.rectangle"), style: .done, target: self, action: #selector(didTapAddButton))
    }
    
    @objc private func didTapAddButton(){
        var textFild = UITextField()
        
        let alert = UIAlertController(title: "Add new to do item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ad Item", style: .default) { (action) in
            textFild.resignFirstResponder()
            
            guard let todo = textFild.text, !todo.isEmpty else {  return }
            
        
            let newTodo = Task(context: self.context)
            newTodo.title = todo
            newTodo.done = false
            
            self.data.append(newTodo)
            self.saveData()
            
        }
        
        let dismissAction = UIAlertAction(title: "Dissmis", style: .destructive) { (_) in
            textFild.resignFirstResponder()
        }
        alert.addAction(action)
        alert.addAction(dismissAction)
        alert.addTextField { (alertTextFild) in
            textFild.placeholder = "Create new item"
            textFild = alertTextFild
            textFild.becomeFirstResponder()
        }
        present(alert,animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       NSLayoutConstraint.activate([
           tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
           tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
           tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
           tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
       ])
    }
}


extension HomeVC:UITableViewDelegate, UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row].title
        cell.accessoryType = data[indexPath.row].done ? .checkmark : .none
        saveData()
        return cell
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        context.delete(data[indexPath.row])
        data.remove(at: indexPath.row)
        
        //data[indexPath.row].done = !data[indexPath.row].done
       
        saveData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
    func saveData(){
        let encoder = PropertyListEncoder()
        do {
            try context.save()
        }catch{
            print(error.localizedDescription)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    func loadData(){
        let request :NSFetchRequest<Task> = Task.fetchRequest()
        do{
          data =  try context.fetch(request)
        }catch{
            print(error.localizedDescription)
        }
        
    }
}



