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
    @IBOutlet weak var tbleView: UITableView!
    var sosList: [SosNumberElement] = []
    
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

extension SOSViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sosList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SOSViewControllerCell") as? SOSViewControllerCell else { return UITableViewCell() }
        if self.sosList.count > 0, let details = sosList[indexPath.row] as? SosNumberElement {
            cell.titleLbl.text = details.sosNumberDescription
            cell.cellBtn.setTitle(details.tollNumber, for: .normal)
        }
        return cell
        
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
        /*
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
        */
        
        
        Utility.showLoaderWithTextMsg(text: "Loading...")
        let urlString = Constants.APIServices.getSOSlist
        
        var request = URLRequest(url: URL(string: urlString)!,timeoutInterval: Double.infinity)
        request.addValue("Basic cGF0bmE6cGF0bmEjMjAyMA==", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            Utility.hideLoader()
            guard let data = data else {
                print(String(describing: error))
                return
            }
            print(String(data: data, encoding: .utf8)!)
            let sosNumber = try? newJSONDecoder().decode(SosNumber.self, from: data)
            self.sosList = sosNumber!
            self.tbleView.reloadData()

        }
        
        task.resume()

        /*
         [{"TollFreeNoId":1,"TollNumber":"1902","IsActive":true,"Description":"Kumbh Helpline Number"},{"TollFreeNoId":2,"TollNumber":"+91-1334-222725","IsActive":true,"Description":"Kumbh Helpline Number"},{"TollFreeNoId":3,"TollNumber":"+91-1334-222726","IsActive":true,"Description":"Kumbh Helpline Number"},{"TollFreeNoId":4,"TollNumber":"+91-1334-222727","IsActive":true,"Description":"Kumbh Helpline Number"},{"TollFreeNoId":5,"TollNumber":"100","IsActive":true,"Description":"Police"},{"TollFreeNoId":6,"TollNumber":"112","IsActive":true,"Description":"Emergency Helpline"},{"TollFreeNoId":7,"TollNumber":"101","IsActive":true,"Description":"Fire Stations"},{"TollFreeNoId":8,"TollNumber":"108","IsActive":true,"Description":"Ambulance"},{"TollFreeNoId":9,"TollNumber":"1075","IsActive":true,"Description":"Covid Helpline"},{"TollFreeNoId":10,"TollNumber":"1090","IsActive":true,"Description":"Women Helpline"},{"TollFreeNoId":11,"TollNumber":"1098","IsActive":true,"Description":"Child Helpline"},{"TollFreeNoId":12,"TollNumber":"1070","IsActive":true,"Description":"Disaster Helpline"}]
         */
        
        
        
        
        
        
    }
    
    
    
}



class SOSViewControllerCell: UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var cellBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func cellAction(_ sender: Any) {
        let phoneNumber = (sender as? UIButton)?.titleLabel?.text
        guard let url = URL(string: "tel://\(phoneNumber)"),
              UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
    }
    
}

typealias SosNumber = [SosNumberElement]
struct SosNumberElement: Codable {
    let tollFreeNoID: Int
    let tollNumber: String
    let isActive: Bool
    let sosNumberDescription: String

    enum CodingKeys: String, CodingKey {
        case tollFreeNoID = "TollFreeNoId"
        case tollNumber = "TollNumber"
        case isActive = "IsActive"
        case sosNumberDescription = "Description"
    }
}
