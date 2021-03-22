//
//  CustomView.swift
//  Kumbhdwar
//
//  Created by Narender Kumar on 14/03/21.
//  Copyright © 2021 Narender Kumar. All rights reserved.
//

import UIKit

class CustomView: UIView {
  //initWithFrame to init view from code
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  //initWithCode to init view from xib or storyboard
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }
  
  //common func to init our view
  private func setupView() {
    backgroundColor = .white
    layer.cornerRadius = 8.0
    layer.borderWidth = 1.5
    layer.borderColor = AppStyleGuide.NewUI.Colors.appBg.cgColor
  }
}
