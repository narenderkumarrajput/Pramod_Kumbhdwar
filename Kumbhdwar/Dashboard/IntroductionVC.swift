//
//  IntroductionVC.swift
//  Kumbhdwar
//
//  Created by Peoplelink on 3/14/21.
//  Copyright © 2021 Narender Kumar. All rights reserved.
//

import UIKit
import WebKit

class IntroductionVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var imageView: UIImageView!
    var text = ""
    var index = -1
    var loadText = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = text
        webView.navigationDelegate = self
//        if url.count > 0, let url = URL(string: url) {
//            Utility.showLoaderWithTextMsg(text: "Loading...")
//            webView.load(URLRequest(url: url))
//            webView.allowsBackForwardNavigationGestures = true
//        }
        if index == 0 {
            loadText = "introductionEnglish"
        } else {
            loadText = "holycityenglish"
        }
        if let filePath = Bundle.main.url(forResource: loadText, withExtension: "docx") {
            Utility.showLoaderWithTextMsg(text: "Loading...")
            let request = NSURLRequest(url: filePath)
            webView.load(request as URLRequest)
            webView.allowsBackForwardNavigationGestures = true

        }
        imageView.borderWithColor(enable: true, withRadius: imageView.frame.height/2, width: 1.0, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.8734749572))
    }

    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension IntroductionVC: WKNavigationDelegate {
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
