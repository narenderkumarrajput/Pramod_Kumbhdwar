//
//  LeaveCell.swift
//  Kumbhdwar
//
//  Created by Peoplelink on 3/28/21.
//  Copyright © 2021 Narender Kumar. All rights reserved.
//

import UIKit

class LeaveCell: UITableViewCell {

    @IBOutlet weak var mainBGView: UIView!
    @IBOutlet weak var subBgView: UIView!
    @IBOutlet weak var loginIdLabel: UILabel!
    @IBOutlet weak var isApprovedLabel: UILabel!
    @IBOutlet weak var approvedOn: UILabel!
    @IBOutlet weak var approvedRemarkLabel: UILabel!
    @IBOutlet weak var remarkLabel: UILabel!
    @IBOutlet weak var assignedOnLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    
    @IBOutlet weak var loginIdLangText: UILabel!
    @IBOutlet weak var isApprovedOnLAngText: UILabel!
    @IBOutlet weak var approvedOnLangText: UILabel!
    @IBOutlet weak var approvedRemarkLangText: UILabel!
    @IBOutlet weak var remarkLAngText: UILabel!
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
        loginIdLangText.text = "Login Id :".localized()
        isApprovedOnLAngText.text = "Is Approved :".localized()
        approvedOnLangText.text = "Approved On :".localized()
        approvedRemarkLangText.text = "Approved Remark :".localized()
        remarkLAngText.text = "Remark :".localized()
        assignedOnLangText.text = "Assigned On :".localized()
        fromLangText.text = "From :".localized()
        toLangText.text = "To :".localized()
    }
    
    
    func setupCell(details: [String: Any]) {
        if let text = details["LoginId"] as? String {
            self.loginIdLabel.text = text
        }
        if let text = details["Remark"] as? String {
            self.remarkLabel.text = text
        }
        if let text = details["ApprovedOn"] as? String {
            self.approvedOn.text = text
        }
        if let text = details["ApprovedRemark"] as? String {
            self.approvedRemarkLabel.text = text
        }
        if let text = details["AssingedOn"] as? String {
            self.assignedOnLabel.text = text
        }
        if let text = details["IsApproved"] as? String {
            self.isApprovedLabel.text = text
        }
        if let text = details["FromDate"] as? String {
            self.fromLabel.text = text
        }
        if let text = details["ToDate"] as? String {
            self.toLabel.text = text
        }
        
    }

}
