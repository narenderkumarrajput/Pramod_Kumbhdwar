//
//  ImageVC.swift
//  Kumbhdwar
//
//  Created by Peoplelink on 3/24/21.
//  Copyright © 2021 Narender Kumar. All rights reserved.
//

import UIKit

class ImageVC: UIViewController {

    @IBOutlet weak var myImageView: UIImageView!
    var url = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let imageUrl = URL(string: url) else { return }
//        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//            guard let data = data, error == nil else { return }
//
//            DispatchQueue.main.async { /// execute on main thread
//                self.imageView.image = UIImage(data: data)
//            }
//        }
//
//        task.resume()
        let task = URLSession.shared.dataTask(
            with: imageUrl,
            completionHandler: { data, response, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async { /// execute on main thread
                    self.myImageView.image = UIImage(data: data)
                }
            })
        task.resume()
    }

    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
