//
//  TrackerCell.swift
//  Kumbhdwar
//
//  Created by Peoplelink on 3/20/21.
//  Copyright © 2021 Narender Kumar. All rights reserved.
//

import UIKit
import Localize_Swift

class TrackerCell: UITableViewCell {

    @IBOutlet weak var mainBGView: UIView!
    @IBOutlet weak var subBgView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contactNoLabel: UILabel!
    @IBOutlet weak var groupTypeLabel: UILabel!
    @IBOutlet weak var trackerButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var nameLangText: UILabel!
    @IBOutlet weak var contactNoLangText: UILabel!
    @IBOutlet weak var groupTypeLangText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupText()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI() {
        mainBGView.borderWithColor(enable: true, withRadius: 5.0, width: 1.0, color: UIColor.white.withAlphaComponent(0.1))
        subBgView.borderWithColor(enable: true, withRadius: 10.0, width: 1.0, color: UIColor(named: "PrimaryColor") ?? .red)
        trackerButton.borderWithColor(enable: true, withRadius: 10.0, width: 1.0, color: UIColor(named: "PrimaryColor") ?? .red)
        nameLangText.text = Constants.Placeholders.name
        contactNoLangText.text = Constants.Placeholders.contact
        groupTypeLangText.text = Constants.Placeholders.groupType
        trackerButton.setTitle(Constants.Placeholders.trackLocation, for: .normal)
    }
    
    func setupText() {
        nameLangText.text = Constants.Placeholders.name.localized()
        contactNoLangText.text = Constants.Placeholders.contact.localized()
        groupTypeLangText.text = Constants.Placeholders.groupType.localized()
        trackerButton.setTitle(Constants.Placeholders.trackLocation, for: .normal)
    }
    func setupCell(details: [String: Any]) {
        if let text = details["Name"] as? String {
            self.nameLabel.text = text
        }
        if let text = details["ContactNo"] as? String {
            self.contactNoLabel.text = text
        }
        if let text = details["GroupType"] as? String {
            self.groupTypeLabel.text = text
        }
    }

}
