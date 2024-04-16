//
//  TipsViewController.swift
//  WaitressBook
//
//  Created by  on 4/4/24.
//

import UIKit


class TipsViewController: UIViewController, TipAdditionDelegate {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var tipsToday: UILabel!
    
    
    var tipsForTables: [Tips] = []
    
    var totalTips: Double = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(tipsForTables)
        print(totalTips)
        tipsToday.text = "Today's Total: \(String(format: "%.2f", totalTips))$"
        styleTableHeader()
        tableView.dataSource = self
        tableView.reloadData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tipsToday.text = "Today's Total: \(String(format: "%.2f", totalTips))$"
        tableView.reloadData()
    }
    
    func updateTipsView(with tip: Tips) {
        tipsForTables.append(tip)
        tableView.reloadData()
        print("Updated Tips: ----")
    }
    
    func styleTableHeader() {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 50))
            //headerView.backgroundColor = UIColor.systemGray5
            
            let headerLabel = UILabel(frame: headerView.bounds)
            headerLabel.text = "Tips By Table"
            headerLabel.textAlignment = .center
            headerLabel.font = UIFont.systemFont(ofSize: 18)
            
            headerView.addSubview(headerLabel)
            tableView.tableHeaderView = headerView
    }
    
    func didAddTip(_ tip: Tips) {
        tipsForTables.append(tip)
        totalTips += tip.tipAmount
        print("did AddTip Delegate Called")
    }
}


extension TipsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tipsForTables.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tipCell", for: indexPath) as! CustomTableViewCell
            let tip = tipsForTables[indexPath.row]
            
            cell.cellTableName.text = "Table: \(tip.table.tableName)"
            cell.cellTipAmount.text = "Tip: $\(tip.tipAmount)"
            cell.cellDate.text = "\(formatTimeStamp(tip.timeStamp))"
            return cell
    }
    
    private func formatTimeStamp(_ timeStamp: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d: HH:mm"
        return dateFormatter.string(from: timeStamp)
    }
}

