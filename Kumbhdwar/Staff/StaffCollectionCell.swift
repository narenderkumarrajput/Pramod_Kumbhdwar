//
//  StaffCollectionCell.swift
//  Kumbhdwar
//
//  Created by Peoplelink on 3/25/21.
//  Copyright © 2021 Narender Kumar. All rights reserved.
//

import UIKit

class StaffCollectionCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.round()
    }
    
    
}
