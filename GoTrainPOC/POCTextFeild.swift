//
//  POCTextFeild.swift
//  GoTrainPOC
//
//  Created by Bahram Haddadi on 2017-10-19.
//  Copyright © 2017 Bahram Haddadi. All rights reserved.
//

import UIKit

@IBDesignable
class POCTextFeild: UITextField {

    @IBInspectable var borderWidth: CGFloat = 0.0
    @IBInspectable var borderColor: UIColor = UIColor.clear
    @IBInspectable var cornerRadius: CGFloat = 0.0
    
    override func draw(_ rect: CGRect) {
        self.layer.borderWidth = self.borderWidth
        self.layer.borderColor = self.borderColor.cgColor
        self.layer.cornerRadius = self.cornerRadius
    }

}
