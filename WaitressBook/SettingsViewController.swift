//
//  SettingsViewController.swift
//  WaitressBook
//
//  Created by  on 4/4/24.
//

import UIKit

struct Section {
    let title: String
    let options: [SettingOptionType]
}

enum SettingOptionType {
    case staticCell(model: SettingsOption)
    case switchCell(model: SettingsSwitchOption)
}
struct SettingsSwitchOption {
    let title: String
    let icon: UIImage?
    let iconBackgroundColor: UIColor
    let handler: (() -> Void)
    var isOn: Bool
}

struct SettingsOption {
    let title: String
    let icon: UIImage?
    let iconBackgroundColor: UIColor
    let handler: (() -> Void)
}

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(SettingTableViewCell.self,
                       forCellReuseIdentifier: SettingTableViewCell.identifier)
        table.register(SwitchTableViewCell.self,
                       forCellReuseIdentifier: SwitchTableViewCell.identifier)
        return table
    }()
    
    var models = [Section]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        title = "Settings"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
    }

    func configure() {
        models.append(Section(title: "Pro Edition ⭐️", options: [
            .staticCell(model: SettingsOption(title: "Menu Presets", icon: UIImage(systemName: "star.fill"), iconBackgroundColor: .systemOrange) {
            }),
            .staticCell(model: SettingsOption(title: "Tip Preset Calculator", icon: UIImage(systemName: "star.fill"), iconBackgroundColor: .systemOrange) {
                
            }),
            .staticCell(model: SettingsOption(title: "Customization", icon: UIImage(systemName: "pencil.and.outline"), iconBackgroundColor: .systemOrange) {
                
            })
        ]))
        models.append(Section(title: "General", options: [
            .staticCell(model: SettingsOption(title: "Notifications", icon: UIImage(systemName: "bell"), iconBackgroundColor: .systemYellow) {
                
            }),
            .staticCell(model: SettingsOption(title: "Currency", icon: UIImage(systemName: "dollarsign.circle.fill"), iconBackgroundColor: .systemGreen) {
                
            }),
            .switchCell(model: SettingsSwitchOption(title: "Dark Mode", icon: UIImage(systemName:"moon.stars.fill"), iconBackgroundColor: .systemGray, handler: {
                [weak self] in self?.toggleDarkMode()
            }, isOn: false))
        ]))
    }
    
    func toggleDarkMode() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        let currentStyle = windowScene.windows.first?.overrideUserInterfaceStyle
        let newStyle: UIUserInterfaceStyle = currentStyle == .dark ? .light : .dark
        windowScene.windows.forEach { window in
            window.overrideUserInterfaceStyle = newStyle
            
        }
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = models[section]
        return section.title
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = models[indexPath.section].options[indexPath.row]
        
        switch model.self {
        case .staticCell(let model):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SettingTableViewCell.identifier, for: indexPath)
                    as? SettingTableViewCell else {
                return UITableViewCell()
            }
            
            cell.configure(with: model)
            return cell
        case .switchCell(let model):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SwitchTableViewCell.identifier, for: indexPath)
                    as? SwitchTableViewCell else {
                return UITableViewCell()
            }
            
            cell.configure(with: model)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let type = models[indexPath.section].options[indexPath.row]
        switch type.self {
        case .staticCell(let model):
            model.handler()
        case .switchCell(let model):
            model.handler()
        }
    }
    
}
