import UIKit

class StatusCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var statusButton: UIButton!
    
    // Closure that will be called when button is tapped
    var onStatusTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 8
        layer.masksToBounds = true
        
        // Add action to button
        statusButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    func configure(title: String, isSelected: Bool) {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.titleAlignment = .center
        
        // Padding inside the button
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12)
        
        // Rounded corners
        config.background.cornerRadius = 18 // slightly less than half the height
        
        if isSelected {
            // Selected button: green, no border
            config.baseBackgroundColor = UIColor(named: "greenCol")
            config.baseForegroundColor = .white
            config.background.strokeWidth = 0
        } else {
            // Unselected buttons: white background, light black border
            config.baseBackgroundColor = .white
            config.baseForegroundColor = .black
            config.background.strokeWidth = 1
            config.background.strokeColor = UIColor.black.withAlphaComponent(0.2)
        }
        
        statusButton.configuration = config
    }

    @objc private func buttonTapped() {
        onStatusTapped?()
    }
}
