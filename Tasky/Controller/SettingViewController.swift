//
//  SettingViewController.swift
//  Tasky
//
//  Created by Akhadjon Abdukhalilov on 9/10/20.
//  Copyright © 2020 Akhadjon Abdukhalilov. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSave))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancel))
    }
    
    
    @objc func didTapSave(){
        
    }
    @objc func didTapCancel(){
        dismiss(animated: true, completion: nil)
    }

   

}
