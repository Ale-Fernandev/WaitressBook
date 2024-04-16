import UIKit

class SwitchTableViewCell: UITableViewCell {
    
    static let identifier = "SwitchTableViewCell"
    
    private let iconContainer: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private let mySwitch: UISwitch = {
        let mySwitch = UISwitch()
        mySwitch.onTintColor = .systemBlue
        return mySwitch
    }()
    
    // Add a property to store the SettingsSwitchOption model
    private var model: SettingsSwitchOption?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(iconContainer)
        contentView.addSubview(mySwitch)
        iconContainer.addSubview(iconImageView)
        
        contentView.clipsToBounds = true
        accessoryType = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size: CGFloat = contentView.frame.size.height - 12
        iconContainer.frame = CGRect(x: 20, y: 6, width: size, height: size)
        
        let imageSize: CGFloat = size / 1.5
        iconImageView.frame = CGRect(x: (size - imageSize) / 2, y: (size - imageSize) / 2, width: imageSize, height: imageSize)
        
        mySwitch.sizeToFit()
        mySwitch.frame = CGRect(x: contentView.frame.size.width - mySwitch.frame.size.width - 20,
                                y: (contentView.frame.size.height - mySwitch.frame.size.height) / 2,
                                width: mySwitch.frame.size.width,
                                height: mySwitch.frame.size.height)
        
        label.frame = CGRect(x: 30 + iconContainer.frame.size.width,
                             y: 0,
                             width: contentView.frame.size.width - 30 - iconContainer.frame.size.width - mySwitch.frame.size.width - 30,
                             height: contentView.frame.size.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        label.text = nil
        iconContainer.backgroundColor = nil
        mySwitch.isOn = false
        mySwitch.removeTarget(nil, action: nil, for: .allEvents)  // Clean up to prevent duplicate actions
    }
    
    public func configure(with model: SettingsSwitchOption) {
        self.model = model  // Store the model for access in the action handler
        label.text = model.title
        iconImageView.image = model.icon
        iconContainer.backgroundColor = model.iconBackgroundColor
        mySwitch.isOn = model.isOn
        mySwitch.addTarget(self, action: #selector(switchToggled), for: .valueChanged)
    }
    
    @objc private func switchToggled(_ sender: UISwitch) {
        // Directly change the interface style and update the model state
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let newStyle: UIUserInterfaceStyle = sender.isOn ? .dark : .light
            windowScene.windows.forEach { window in
                window.overrideUserInterfaceStyle = newStyle
            }
        }
        model?.isOn = sender.isOn  // Update the model state
    }
}

