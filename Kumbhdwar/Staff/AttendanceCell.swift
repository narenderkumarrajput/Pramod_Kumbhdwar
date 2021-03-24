//
//  AttendanceCell.swift
//  Kumbhdwar
//
//  Created by Peoplelink on 3/25/21.
//  Copyright © 2021 Narender Kumar. All rights reserved.
//

import UIKit

class AttendanceCell: UITableViewCell {

    @IBOutlet weak var mainBgView: UIView!
    @IBOutlet weak var subBgView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contactNoLabel: UILabel!
    @IBOutlet weak var designationLabel: UILabel!
    @IBOutlet weak var wardNoLabel: UILabel!
    @IBOutlet weak var zoneNoLabel: UILabel!
    @IBOutlet weak var punchInTimeLabel: UILabel!
    @IBOutlet weak var punchOutTimeLabel: UILabel!
    @IBOutlet weak var punchInLocationButton: UIButton!
    @IBOutlet weak var punchOutLocationButton: UIButton!
    @IBOutlet weak var punchInView: UIView!
    @IBOutlet weak var punchOutView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI() {
        mainBgView.borderWithColor(enable: true, withRadius: 5.0, width: 1.0, color: UIColor.white.withAlphaComponent(0.1))
        subBgView.borderWithColor(enable: true, withRadius: 10.0, width: 1.0, color: UIColor(named: "PrimaryColor") ?? .red)
        punchInView.borderWithColor(enable: true, withRadius: 10.0, width: 1.0, color: UIColor(named: "PrimaryColor") ?? .red)
        punchOutView.borderWithColor(enable: true, withRadius: 10.0, width: 1.0, color: UIColor(named: "PrimaryColor") ?? .red)

    }
    func setupCell(details: [String: Any]) {
        if let text = details["Name"] as? String {
            self.nameLabel.text = text
        }
        if let text = details["ContactNo"] as? String {
            self.contactNoLabel.text = text
        }
        if let text = details["Designation"] as? String {
            self.designationLabel.text = text
        }
        if let text = details["WardNo"] as? String {
            self.wardNoLabel.text = text
        }
        if let text = details["ZoneNo"] as? String {
            self.zoneNoLabel.text = text
        }
        if let text = details["PunchInTime"] as? String {
            self.punchInTimeLabel.text = text
        }
        if let text = details["PunchOutTime"] as? String {
            self.punchOutTimeLabel.text = text
        }
    }

}
