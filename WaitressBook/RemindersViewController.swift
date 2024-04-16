//
//  MenusViewController.swift
//  WaitressBook
//
//  Created by  on 4/4/24.
//
import UserNotifications
import UIKit

class RemindersViewController: UIViewController {
    
    
    @IBOutlet var table: UITableView!
    
    var models = [myReminder]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
    }
    
    @IBAction func didTapAdd() {
        // Show add ViewController
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "add") as? AddViewController else {
            return
        }
        
        vc.title = "New Reminder"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = { title, body, date in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                let new = myReminder(title: title, date: date, identifier: "id_\(title)")
                self.models.append(new)
                self.table.reloadData()
                
                let content = UNMutableNotificationContent()
                content.title = title
                content.sound = .default
                content.body = body
                
                let targetDate = date
                let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: false)
                
                let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                    if error != nil {
                        print("Something went wrong")
                    }
                })
                
            }
        }
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func didTapTest() {
        // fire test notifcation
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { success, error in
            if success {
                // schedule test
                self.scheduleTest()
            }
            else if error != nil {
                print("Error Occurred")
            }
        })
    }
    
    func scheduleTest() {
        let content = UNMutableNotificationContent()
        content.title = "Hello World"
        content.sound = .default
        content.body = "My Long Body, My Long Body, My Long Body, My Long Body, My Long Body"
        
        let targetDate = Date().addingTimeInterval(10)
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: false)
        
        let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
            if error != nil {
                print("Something went wrong")
            }
        })
    }

    
}

extension RemindersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension RemindersViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }
            
            
            self.models.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeActions.performsFirstActionWithFullSwipe = false
        return swipeActions
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row].title.capitalized
        
        let date = models[indexPath.row].date
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d: HH:mm"
        cell.detailTextLabel?.text = formatter.string(from: date)
        
        return cell
    }
}

struct myReminder {
    let title: String
    let date: Date
    let identifier: String
}
