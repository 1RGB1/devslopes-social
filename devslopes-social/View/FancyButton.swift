//
//  FancyButton.swift
//  devslopes-social
//
//  Created by Ahmad Ragab on 10/24/17.
//  Copyright © 2017 Ahmad Ragab. All rights reserved.
//

import UIKit

class FancyButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: SHADOW_GREY, green: SHADOW_GREY, blue: SHADOW_GREY, alpha: 0.6).cgColor
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.8
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.cornerRadius = 0.2
    }
}
