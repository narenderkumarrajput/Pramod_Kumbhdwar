//
//  JourneyCell.swift
//  Kumbhdwar
//
//  Created by Peoplelink on 3/19/21.
//  Copyright © 2021 Narender Kumar. All rights reserved.
//

import UIKit

class JourneyCell: UITableViewCell {

    @IBOutlet weak var mainBGView: UIView!
    @IBOutlet weak var subBGView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contactNoLAbel: UILabel!
    @IBOutlet weak var parkingNameLabel: UILabel!
    @IBOutlet weak var ghatNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var travelModeLabel: UILabel!
    @IBOutlet weak var personLabel: UILabel!
    @IBOutlet weak var visitDateLAbel: UILabel!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var locationButtonOterView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupUI() {
        mainBGView.borderWithColor(enable: true, withRadius: 5.0, width: 1.0, color: UIColor.white.withAlphaComponent(0.1))
        subBGView.borderWithColor(enable: true, withRadius: 10.0, width: 1.0, color: UIColor(named: "PrimaryColor") ?? .red)
        locationButtonOterView.borderWithColor(enable: true, withRadius: 10.0, width: 1.0, color: UIColor(named: "PrimaryColor") ?? .red)
    }
    
    func setupCell(details: [String:Any]) {
        if let name = details["VisitorName"] as? String {
            self.nameLabel.text = name
        }
        if let contactNo = details["VisitorId"] as? String {
            self.contactNoLAbel.text = contactNo
        }
        if let parkingName = details["ParkingName"] as? String {
            self.parkingNameLabel.text = parkingName
        }
        if let ghatName = details["DestinationGhatName"] as? String {
            self.ghatNameLabel.text = ghatName
        }
        if let address = details["SourceAddress"] as? String {
            self.addressLabel.text = address
        }
        if let travelMode = details["TravelMode"] as? String {
            self.travelModeLabel.text = travelMode
        }
        if let person = details["AccompanyingPersons"] as? String {
            self.personLabel.text = person
        }
        if let visitDate = details["VisitingDate"] as? String {
            self.visitDateLAbel.text = visitDate
        }
    }
    
}
