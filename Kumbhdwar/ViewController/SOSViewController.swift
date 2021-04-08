//
//  SOSViewController.swift
//  Kumbhdwar
//
//  Created by Narender Kumar on 17/03/21.
//  Copyright © 2021 Narender Kumar. All rights reserved.
//

import UIKit

class SOSViewController: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var sosBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.setTitle("KUMBHDWAR", subtitle: "Welcome To Haridwar Maha Kumbh Mela")
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = AppStyleGuide.NewUI.Colors.appBg
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "ic_arrow_back_white_24dp"), for: .normal)
        button.addTarget(self, action:#selector(SOSViewController.backAction), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItems = [barButton]
        
        topView.clipsToBounds = true
        topView.layer.cornerRadius = 10
        topView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        self.getSOSList()
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sosAction(_ sender: Any) {
        self.callNumber(phoneNumber: "101")
    }
    
    private func callNumber(phoneNumber: String) {
        guard let url = URL(string: "tel://\(phoneNumber)"),
            UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
}


extension UINavigationItem {

  func setTitle(_ title: String, subtitle: String) {
    let appearance = UINavigationBar.appearance()
    let textColor = appearance.titleTextAttributes?[NSAttributedString.Key.foregroundColor] as? UIColor ?? .white

    let titleLabel = UILabel()
    titleLabel.text = title
    titleLabel.font = .preferredFont(forTextStyle: UIFont.TextStyle.headline)
    titleLabel.textColor = textColor

    let subtitleLabel = UILabel()
    subtitleLabel.text = subtitle
    //subtitleLabel.font = .preferredFont(forTextStyle: UIFont.TextStyle.subheadline)
    subtitleLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.regular)
    subtitleLabel.textColor = textColor

    let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
    stackView.distribution = .equalCentering
    stackView.alignment = .center
    stackView.axis = .vertical

    self.titleView = stackView
  }
}




extension SOSViewController {
    
    private func getSOSList() {

        let headers = ["Authorization":"Basic cGF0bmE6cGF0bmEjMjAyMA==","Content-Type":"application/json"] as [String:String]
        Utility.showLoaderWithTextMsg(text: "Loading...")
        var urlString = Constants.APIServices.getSOSlist
        NetworkManager.requestGETURL(urlString, headers: headers) { (responseJSON) in
            Utility.hideLoader()
            print(responseJSON)
            if responseJSON.count > 0, let arrayOfObjects = responseJSON.arrayObject as? [[String:Any]] {
                print("arrayOfObjects")
            } else {
                print("arrayOfObjects ---")
            }
        } failure: { (error) in
            print(error)
            Utility.hideLoader()
        }
    }
    
    
    
}
