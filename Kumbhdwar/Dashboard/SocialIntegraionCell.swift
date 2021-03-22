//
//  SocialIntegraionCell.swift
//  Kumbhdwar
//
//  Created by Peoplelink on 3/14/21.
//  Copyright © 2021 Narender Kumar. All rights reserved.
//

import UIKit

class SocialIntegraionCell: UICollectionViewCell {
    
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var instagramButton: UIButton!
    
   
    override func layoutSubviews() {
        super.layoutSubviews()
        facebookButton.circleWithBorderColor(color: #colorLiteral(red: 1, green: 0.3098039216, blue: 0.07843137255, alpha: 1), width: 1.0)
        twitterButton.circleWithBorderColor(color: #colorLiteral(red: 1, green: 0.3098039216, blue: 0.07843137255, alpha: 1), width: 1.0)
        instagramButton.circleWithBorderColor(color: #colorLiteral(red: 1, green: 0.3098039216, blue: 0.07843137255, alpha: 1), width: 1.0)
    }
    
}
