//
//  HomeViewController.swift
//  WaitressBook
//
//  Created by  on 4/2/24.
//

import UIKit


protocol TipAdditionDelegate: AnyObject {
    func didAddTip(_ tip: Tips)
    
}


class HomeViewController: UIViewController {

        
    weak var delegate: TipAdditionDelegate?
    
    @IBOutlet var tableView: UITableView!
    
    
    var tables = [Table]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let tabBarController = self.tabBarController {
            for viewController in tabBarController.viewControllers ?? [] {
                if let tipsVC = viewController as? TipsViewController {
                    self.delegate = tipsVC
                    print("Delegate set to TipsViewController")
                    break
                }
            }
        }
    }
    
    func handleTipAdded(_ tip: Tips) {
        delegate?.didAddTip(tip)
    }
    
    
    func showTipsAlert(for indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Tips", message: "Enter Tips Here:", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Enter tip amount"
            textField.keyboardType = .decimalPad  // Ensures number input
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let self = self,
                  let tipsText = alertController.textFields?.first?.text,
                  let tips = Double(tipsText.trimmingCharacters(in: .whitespacesAndNewlines)) else {
                print("Failed to get necessary data for saving tips")
                return
            }

            let table = self.tables[indexPath.row]
            let tip = Tips(table: table, tipAmount: tips)

            // Updating tips
            self.delegate?.didAddTip(tip)
            print("Delegate called to update tips.")

            // Removing the table
            self.tables.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            print("Table removed.")
            
            
            UserDefaults.standard.removeObject(forKey: table.tableName)
        }
        alertController.addAction(saveAction)
        
        // Present the alert
        self.present(alertController, animated: true)
    }
    
    
    
    @IBAction func didTapNew() {
        guard let cvc = storyboard?.instantiateViewController(identifier: "create") as? CreateTableViewController else {
            return
        }
        
        cvc.title = "Create Table"
        cvc.onCreateTable = { tableName, amountSeated in DispatchQueue.main.async {
            self.navigationController?.popToRootViewController(animated: true)
            let newT = Table(tableName: tableName, amountSeated: amountSeated)
            self.tables.append(newT)
            self.tableView.reloadData()
        }
        }
        navigationController?.pushViewController(cvc, animated: true)
    }

}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let notesvc = storyboard?.instantiateViewController(withIdentifier: "note") as? NotesViewController else {
            return
        }
        let tableName = tables[indexPath.row].tableName
        notesvc.title = "Order For Table: \(tableName)"
        notesvc.tableName = tableName
        navigationController?.pushViewController(notesvc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
                guard let self = self else { return }
            
            let tableName = self.tables[indexPath.row].tableName
            UserDefaults.standard.removeObject(forKey: tableName)
            
            self.tables.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true) // Like a break statement
        }
        
        
        let payAction = UIContextualAction(style: .normal, title: "Pay") { [weak self] (_, _, completionHandler) in
                guard let self = self else { return }
            
            self.showTipsAlert(for: indexPath)
            completionHandler(true)
        }
        payAction.backgroundColor = .systemBlue
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction, payAction])
        swipeActions.performsFirstActionWithFullSwipe = false // Show buttons immediately
        return swipeActions
    }
}
    
extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tables.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        cell.textLabel?.text = "Table: \(tables[indexPath.row].tableName)"
        cell.detailTextLabel?.text = "Amount Seated: \(tables[indexPath.row].amountSeated)"
        
        return cell
    }
}


struct Table {
    let tableName: String
    let amountSeated: String
}
