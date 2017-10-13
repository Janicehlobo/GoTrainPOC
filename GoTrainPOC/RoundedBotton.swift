//
//  RoundedBotton.swift
//  HCMA
//
//  Created by Bahram Haddadi on 2017-03-07.
//  Copyright © 2017 IBM Canada. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedBotton: UIButton {

    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 2.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

    @IBInspectable var text: String = "" {
        didSet {
            setTitle(text, for: .normal)
        }
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
        titleLabel?.textAlignment = .center
    }
}
