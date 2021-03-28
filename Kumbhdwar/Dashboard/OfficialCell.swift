//
//  OfficialCell.swift
//  Kumbhdwar
//
//  Created by Peoplelink on 3/28/21.
//  Copyright © 2021 Narender Kumar. All rights reserved.
//

import UIKit

class OfficialCell: UITableViewCell {

    @IBOutlet weak var mainBgView: UIView!
    @IBOutlet weak var subBgView: UIView!
    @IBOutlet weak var officialNameLabel: UILabel!
    @IBOutlet weak var designationLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var callButton: UIButton!
    
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
        callButton.borderWithColor(enable: true, withRadius: 10.0, width: 1.0, color: UIColor(named: "PrimaryColor") ?? .red)

    }
    func setupCell(details: [String: Any]) {
        if let text = details["Name"] as? String {
            self.officialNameLabel.text = text
        }
        if let text = details["Designation"] as? String {
            self.designationLabel.text = text
        }
        if let text = details["Office"] as? String {
            self.addressLabel.text = text
        }
        if let text = details["PhoneNo"] as? String {
            self.callButton.setTitle(text, for: .normal)
        }
    }

}
