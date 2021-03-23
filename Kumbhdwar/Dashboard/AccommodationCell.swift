//
//  AccommodationCell.swift
//  Kumbhdwar
//
//  Created by Peoplelink on 3/21/21.
//  Copyright © 2021 Narender Kumar. All rights reserved.
//

import UIKit

class AccommodationCell: UITableViewCell {

    @IBOutlet weak var mainBGView: UIView!
    @IBOutlet weak var subBGView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contactNumberLabel: UILabel!
    @IBOutlet weak var bedCapacityLabel: UILabel!
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var locationButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupUI() {
        mainBGView.borderWithColor(enable: true, withRadius: 5.0, width: 1.0, color: UIColor.white.withAlphaComponent(0.1))
        subBGView.borderWithColor(enable: true, withRadius: 10.0, width: 1.0, color: UIColor(named: "PrimaryColor") ?? .red)
        locationButton.borderWithColor(enable: true, withRadius: 10.0, width: 1.0, color: UIColor(named: "PrimaryColor") ?? .red)

    }
    func setupCell(details: [String: Any]) {
        if let text = details["Accomodation_Name"] as? String {
            self.nameLabel.text = text
        }
        if let text = details["ContactNo"] as? String {
            self.contactNumberLabel.text = text
        }
        if let text = details["Total_Room"] as? Int {
            self.roomLabel.text = "\(text)"
        }
        if let text = details["Bed_Capacity"] as? Int {
            self.bedCapacityLabel.text = "\(text)"
        }
        if let text = details["Distance"] as? Double {
            self.distanceLabel.text = "\(text) KM"
        }
        if let text = details["Accomodation_Type"] as? String {
            self.typeLabel.text = text
        }
        if let text = details["Address"] as? String {
            self.addressLabel.text = text
        }
    }
}
