//
//  TaskCell.swift
//  Kumbhdwar
//
//  Created by Peoplelink on 3/27/21.
//  Copyright © 2021 Narender Kumar. All rights reserved.
//

import UIKit
import Localize_Swift

class TaskCell: UITableViewCell {

    @IBOutlet weak var mainBGView: UIView!
    @IBOutlet weak var subBgView: UIView!
    @IBOutlet weak var loginIdLabel: UILabel!
    @IBOutlet weak var circleNameLAbel: UILabel!
    @IBOutlet weak var wardLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var assignedOnLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    
    @IBOutlet weak var loginIdLangText: UILabel!
    @IBOutlet weak var circleNameLangText: UILabel!
    @IBOutlet weak var wardLangText: UILabel!
    @IBOutlet weak var descriptionLangText: UILabel!
    @IBOutlet weak var feedbackLangText: UILabel!
    @IBOutlet weak var assignedOnLangText: UILabel!
    @IBOutlet weak var fromLangText: UILabel!
    @IBOutlet weak var toLangText: UILabel!
    
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
        subBgView.borderWithColor(enable: true, withRadius: 10.0, width: 1.0, color: UIColor(named: "PrimaryColor") ?? .red)
//        locationButton.borderWithColor(enable: true, withRadius: 10.0, width: 1.0, color: UIColor(named: "PrimaryColor") ?? .red)
        loginIdLangText.text = "Login Id :".localized()
        circleNameLangText.text = "Circle Name :".localized()
        wardLangText.text = Constants.Placeholders.ward.localized()
        descriptionLangText.text = Constants.Placeholders.description.localized()
        feedbackLangText.text = Constants.Placeholders.feedback.localized()
        assignedOnLangText.text = "Assigned On :".localized()
        fromLangText.text = "From :".localized()
        toLangText.text = "To :".localized()
    }
    
    func setupCell(details: [String: Any]) {
        if let text = details["UserLoginId"] as? String {
            self.loginIdLabel.text = text
        }
        if let text = details["CircleName"] as? String {
            self.circleNameLAbel.text = text
        }
        if let text = details["WardName"] as? String {
            self.wardLabel.text = text
        }
        if let text = details["TaskDescription"] as? String {
            self.descriptionLabel.text = text
        }
        if let text = details["FeedbackRemark"] as? String {
            self.feedbackLabel.text = text
        }
        if let text = details["AssingedOn"] as? String {
            self.assignedOnLabel.text = text
        }
        if let text = details["FromDate"] as? String {
            self.fromLabel.text = text
        }
        if let text = details["ToDate"] as? String {
            self.toLabel.text = text
        }
        
    }

}
