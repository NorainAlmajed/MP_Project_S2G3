//
//  FilterHeader\Cell.swift
//  Project
//
//  Created by zainab mahdi on 26/12/2025.
//

import UIKit

class FilterHeaderCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var arrowButton: UIButton!
    @IBOutlet weak var dateButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        var config = arrowButton.configuration ?? UIButton.Configuration.plain()

        config.imagePlacement = .all
        config.imagePadding = 0
        config.contentInsets = NSDirectionalEdgeInsets(
            top: 6,
            leading: 6,
            bottom: 6,
            trailing: 6
        )

        arrowButton.configuration = config
        arrowButton.imageView?.contentMode = .scaleAspectFit

        if let image = arrowButton.image(for: .normal) {
            arrowButton.setImage(
                image.withRenderingMode(.alwaysTemplate),
                for: .normal
            )
        }

        applyArrowColor()

        registerForTraitChanges([UITraitUserInterfaceStyle.self]) {
            [weak self] (_: UITraitEnvironment, previous: UITraitCollection) in
            guard let self else { return }

            if previous.userInterfaceStyle != self.traitCollection.userInterfaceStyle {
                self.applyArrowColor()
            }
        }
    }

    
    func applyArrowColor() {
        let isDarkMode = traitCollection.userInterfaceStyle == .dark

        var config = arrowButton.configuration ?? UIButton.Configuration.plain()
        config.baseForegroundColor = isDarkMode
            ? UIColor(red: 0.07, green: 0.39, blue: 0.07, alpha: 1.0)
            : .black

        arrowButton.configuration = config
    }


    
    //buttons and labels configure function
    func configure(title: String, isExpanded: Bool, showsDate: Bool) {
        titleLabel.text = title

        arrowButton.isHidden = showsDate
        dateButton.isHidden = !showsDate

        arrowButton.imageView?.transform = isExpanded
            ? CGAffineTransform(rotationAngle: .pi)
            : .identity
    }

        
        func setDateText(_ text: String?) {
            if let text = text {
                dateButton.setTitle(text, for: .normal)
                dateButton.isHidden = false
            } else {
                dateButton.isHidden = true
            }
        }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        dateButton.layer.cornerRadius = 8
        dateButton.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }


}
