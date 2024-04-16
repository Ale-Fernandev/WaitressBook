//
//  CreateTableViewController.swift
//  WaitressBook
//
//  Created by  on 4/7/24.
//

import UIKit

class CreateTableViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var amountSeated: UITextField!
    @IBOutlet weak var tableName: UITextField!
    
    
    var onCreateTable: ((String, String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amountSeated.delegate = self
        tableName.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .done, target: self, action: #selector(makeTable))
        
    }
    
    @objc func makeTable() {
        if let tableNameText = tableName.text, !tableNameText.isEmpty,
           let amountSeatedText = amountSeated.text, !amountSeatedText.isEmpty {
            onCreateTable?(tableNameText.capitalized, amountSeatedText)
        }
    }
}

