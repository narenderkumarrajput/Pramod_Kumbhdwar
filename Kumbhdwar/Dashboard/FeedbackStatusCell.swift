//
//  FeedbackStatusCell.swift
//  Kumbhdwar
//
//  Created by Peoplelink on 3/18/21.
//  Copyright © 2021 Narender Kumar. All rights reserved.
//

import UIKit
import Localize_Swift

class FeedbackStatusCell: UITableViewCell {

    @IBOutlet weak var feedbackNumberLAbel: UILabel!
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var feedbackDate: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var categoryLAbel: UILabel!
    @IBOutlet weak var addressLAbel: UILabel!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var imageButtonBGView: UIView!
    @IBOutlet weak var locationButtonBGView: UIView!
    @IBOutlet weak var mainBGView: UIView!
    @IBOutlet weak var subBGView: UIView!
    
    @IBOutlet weak var feedbackDateLangsText: UILabel!
    @IBOutlet weak var feedbackNoLangText: UILabel!
    @IBOutlet weak var feedbackLangText: UILabel!
    @IBOutlet weak var statusLangText: UILabel!
    @IBOutlet weak var descriptionLangText: UILabel!
    @IBOutlet weak var categoryLangText: UILabel!
    @IBOutlet weak var addressLangText: UILabel!
    
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
        locationButtonBGView.borderWithColor(enable: true, withRadius: 10.0, width: 1.0, color: UIColor(named: "PrimaryColor") ?? .red)
        imageButtonBGView.borderWithColor(enable: true, withRadius: 10.0, width: 1.0, color: UIColor(named: "PrimaryColor") ?? .red)
        feedbackNoLangText.text = Constants.Placeholders.feedbackNo
        feedbackLangText.text = Constants.Placeholders.feedback
        statusLangText.text = Constants.Placeholders.status
        feedbackDateLangsText.text = Constants.Placeholders.feedbackDate
        descriptionLangText.text = Constants.Placeholders.description
        categoryLangText.text = Constants.Placeholders.category
        addressLangText.text = Constants.Placeholders.address
        locationButton.setTitle(Constants.Placeholders.direction, for: .normal)
    }
    
    func setupText() {
        feedbackNoLangText.text = Constants.Placeholders.feedbackNo.localized()
        feedbackLangText.text = Constants.Placeholders.feedback.localized()
        statusLangText.text = Constants.Placeholders.status.localized()
        feedbackDateLangsText.text = Constants.Placeholders.feedbackDate.localized()
        descriptionLangText.text = Constants.Placeholders.description.localized()
        categoryLangText.text = Constants.Placeholders.category.localized()
        addressLangText.text = Constants.Placeholders.address.localized()
        locationButton.setTitle(Constants.Placeholders.direction.localized(), for: .normal)
        imageButton.setTitle("Image".localized(), for: .normal)
    }
    
    func setupCell(details: [String:Any]) {
        if let complaintCode = details["ComplaintCode"] as? String{
            self.feedbackNumberLAbel.text = complaintCode
        }
        if let complaint = details["Complaint"] as? String {
            self.feedbackLabel.text = complaint
        }
        if let status = details["Status"] as? String {
            self.statusLabel.text = status
        }
        if let date = details["CreatedOn"] as? String {
            self.feedbackDate.text = date
        }
        if let description = details["Complaint"] as? String {
            self.descriptionLabel.text = description
        }
        if let category = details["CategoryName"] as? String {
            self.categoryLAbel.text = category
        }
        if let address = details[""] as? String {
            self.addressLAbel.text = address
        }
    }
    
}
