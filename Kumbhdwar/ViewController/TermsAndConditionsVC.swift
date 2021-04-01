//
//  TermsAndConditionsVC.swift
//  Kumbhdwar
//
//  Created by Peoplelink on 4/1/21.
//  Copyright © 2021 Narender Kumar. All rights reserved.
//

import UIKit
import WebKit

class TermsAndConditionsVC: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Terms And Conditions"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = AppStyleGuide.NewUI.Colors.appBg
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "ic_arrow_back_white_24dp"), for: .normal)
        button.addTarget(self, action:#selector(self.backBtnAction(_:)), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItems = [barButton]
        
        webView.navigationDelegate = self
        if let filePath = Bundle.main.url(forResource: "TermsofUse", withExtension: "docx") {
            Utility.showLoaderWithTextMsg(text: "Loading...")
            let request = NSURLRequest(url: filePath)
            webView.load(request as URLRequest)
            webView.allowsBackForwardNavigationGestures = true
        }
    }
    @objc func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Started to load")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finished loading")
        Utility.hideLoader()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
}
