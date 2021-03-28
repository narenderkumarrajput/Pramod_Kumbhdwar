//
//  LeaveVC.swift
//  Kumbhdwar
//
//  Created by Peoplelink on 3/28/21.
//  Copyright © 2021 Narender Kumar. All rights reserved.
//

import UIKit

class LeaveVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fromDateTextField: UITextField!
    @IBOutlet weak var toDateTextField: UITextField!
    @IBOutlet weak var fromDateBtnBGView: UIView!
    @IBOutlet weak var toDateBtnBgView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var myDatePicker: UIDatePicker!
    @IBOutlet weak var fromDateOuterView: UIView!
    @IBOutlet weak var toDateOuterView: UIView!
    @IBOutlet weak var applyLeaveButton: UIButton!
    
    var detailsArray = [Any]()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupDateUI()
    }
    private func setupUI() {
        detailsArray.removeAll()
        detailsArray = []
        tableView.estimatedRowHeight = 300.0
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func setupDateUI() {
        
        fromDateOuterView.borderWithColor(enable: true, withRadius: 10.0, width: 1.0, color: UIColor(named: "PrimaryColor") ?? .red)
        toDateOuterView.borderWithColor(enable: true, withRadius: 10.0, width: 1.0, color: UIColor(named: "PrimaryColor") ?? .red)
        fromDateBtnBGView.borderWithColor(enable: true, withRadius: 10.0, width: 1.0, color: UIColor(named: "PrimaryColor") ?? .red)
        toDateBtnBgView.borderWithColor(enable: true, withRadius: 10.0, width: 1.0, color: UIColor(named: "PrimaryColor") ?? .red)
        fromDateTextField.text = stringDate(date: Date())
        toDateTextField.text = stringDate(date: Date())
//        toDateTextField.delegate = self
    }
    
    func stringDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        return formatter.string(from: date)
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func applyLeaveTapped(_ sender: UIButton) {
    
    }
}
extension LeaveVC: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return detailsArray.count > 0 ? detailsArray.count : 0
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.StoryboardIdentifiers.leaveCell) as? LeaveCell else { return UITableViewCell() }
//        if detailsArray.count > 0, let details = detailsArray[indexPath.row] as? [String:Any] {
//            cell.setupCell(details: details)
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func successLabel(view: UIView, message: String, completion: ((Bool) -> Void)?) {
        
        let backgroundView = UIView(frame: CGRect(x: 50, y: view.frame.size.height - 150, width: view.frame.size.width - 80, height: 40))
        
        backgroundView.backgroundColor = #colorLiteral(red: 0.2784313725, green: 0.2784313725, blue: 0.2784313725, alpha: 1)
        backgroundView.round(enable: true, withRadius: nil)
        
        let label = UILabel(frame: CGRect(x: backgroundView.frame.origin.x + 5, y: backgroundView.frame.origin.y, width: backgroundView.frame.width - 10, height: 40))
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = message
        label.numberOfLines = 3
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        view.addSubview(backgroundView)
        view.addSubview(label)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            backgroundView.removeFromSuperview()
            label.removeFromSuperview()
            completion?(true)
        }
        
    }
}
