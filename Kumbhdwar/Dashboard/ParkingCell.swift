//
//  ParkingCell.swift
//  Kumbhdwar
//
//  Created by Peoplelink on 1/1/20.
//  Copyright © 2020 Narender Kumar. All rights reserved.
//

import UIKit
import Localize_Swift

class ParkingCell: UITableViewCell {

    @IBOutlet weak var mainBGView: UIView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var descriptionTextLabel: UILabel!
    @IBOutlet weak var distanceTextLabel: UILabel!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var descriptionLangText: UILabel!
    @IBOutlet weak var distanceLangText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainBGView.borderWithColor(enable: true, withRadius: 10.0, width: 1.0, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        bgView.borderWithColor(enable: true, withRadius: 10.0, width: 1.0, color: #colorLiteral(red: 0.9215686275, green: 0.231372549, blue: 0, alpha: 1))
        locationButton.borderWithColor(enable: true, withRadius: 10.0, width: 1.0, color: #colorLiteral(red: 0.9215686275, green: 0.231372549, blue: 0, alpha: 1))
        setupText()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupText() {
        descriptionLangText.text = Constants.Placeholders.description.localized()
        distanceLangText.text = Constants.Placeholders.distance.localized()
        locationButton.setTitle(Constants.Placeholders.direction.localized(), for: .normal)
    }
    
    func setupCell(details: [String:Any]) {
        if let description = details["Description"] as? String {
            self.descriptionTextLabel.text = description
        }
        if let distance = details["Distance"] as? Double {
            self.distanceTextLabel.text = "\(distance)"
        }
        
    }
    

}
