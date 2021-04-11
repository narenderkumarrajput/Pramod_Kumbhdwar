//
//  AkhadaCell.swift
//  Kumbhdwar
//
//  Created by Peoplelink on 3/21/21.
//  Copyright © 2021 Narender Kumar. All rights reserved.
//

import UIKit
import Localize_Swift

class AkhadaCell: UITableViewCell {

    @IBOutlet weak var mainBgView: UIView!
    @IBOutlet weak var subBgView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var locationButton: UIButton!
    
    @IBOutlet weak var nameLangText: UILabel!
    @IBOutlet weak var distanceLangText: UILabel!
    @IBOutlet weak var addressLangText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
//        setupLocalization()
        setupText()
    }
    private func setupText() {
        nameLangText.text = Constants.Placeholders.name.localized()
        addressLangText.text = Constants.Placeholders.address.localized()
        distanceLangText.text = Constants.Placeholders.distance.localized()
        locationButton.setTitle(Constants.Placeholders.direction.localized(), for: .normal)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupUI() {
        mainBgView.borderWithColor(enable: true, withRadius: 5.0, width: 1.0, color: UIColor.white.withAlphaComponent(0.1))
        subBgView.borderWithColor(enable: true, withRadius: 10.0, width: 1.0, color: UIColor(named: "PrimaryColor") ?? .red)
        locationButton.borderWithColor(enable: true, withRadius: 10.0, width: 1.0, color: UIColor(named: "PrimaryColor") ?? .red)

    }
    func setupCell(details: [String: Any]) {
        if let text = details["Akhada_Name"] as? String {
            self.nameLabel.text = text
        }
        if let text = details["Distance"] as? Double {
            self.distanceLabel.text = " \(text) KM"
        }
        if let text = details["Sector_Name"] as? String {
            self.addressLabel.text = text
        }
    }

}
