//
//  JourneyCell.swift
//  Kumbhdwar
//
//  Created by Peoplelink on 3/19/21.
//  Copyright © 2021 Narender Kumar. All rights reserved.
//

import UIKit
import Localize_Swift

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
    
    @IBOutlet weak var nameLangText: UILabel!
    @IBOutlet weak var contactNoLangText: UILabel!
    @IBOutlet weak var parkingNameLangText: UILabel!
    @IBOutlet weak var ghatNameLangText: UILabel!
    @IBOutlet weak var addressLangText: UILabel!
    @IBOutlet weak var travelModeLangText: UILabel!
    @IBOutlet weak var personLangText: UILabel!
    @IBOutlet weak var visitDateLangText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
        setupText()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupUI() {
        mainBGView.borderWithColor(enable: true, withRadius: 5.0, width: 1.0, color: UIColor.white.withAlphaComponent(0.1))
        subBGView.borderWithColor(enable: true, withRadius: 10.0, width: 1.0, color: UIColor(named: "PrimaryColor") ?? .red)
        locationButtonOterView.borderWithColor(enable: true, withRadius: 10.0, width: 1.0, color: UIColor(named: "PrimaryColor") ?? .red)
        self.nameLangText.text = Constants.Placeholders.name
        self.contactNoLangText.text = Constants.Placeholders.contact
        self.parkingNameLangText.text = Constants.Placeholders.parkingName
        self.ghatNameLangText.text = Constants.Placeholders.ghatName
        self.addressLangText.text = Constants.Placeholders.address
        self.travelModeLangText.text = Constants.Placeholders.travelMode
        self.personLangText.text = Constants.Placeholders.person
        self.visitDateLangText.text = Constants.Placeholders.visitDate
        self.locationButton.setTitle("     Show Journey Route", for: .normal)
        self.deleteButton.setTitle("Delete", for: .normal)
    }
    
    func setupText() {
        self.nameLangText.text = Constants.Placeholders.name.localized()
        self.contactNoLangText.text = Constants.Placeholders.contact.localized()
        self.parkingNameLangText.text = Constants.Placeholders.parkingName.localized()
        self.ghatNameLangText.text = Constants.Placeholders.ghatName.localized()
        self.addressLangText.text = Constants.Placeholders.address.localized()
        self.travelModeLangText.text = Constants.Placeholders.travelMode.localized()
        self.personLangText.text = Constants.Placeholders.person.localized()
        self.visitDateLangText.text = Constants.Placeholders.visitDate.localized()
        self.locationButton.setTitle("     Show Journey Route".localized(), for: .normal)
        self.deleteButton.setTitle("Delete".localized(), for: .normal)
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
