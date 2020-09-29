//
//  Extensions.swift
//  With a Plan
//
//  Created by mac on 23.09.2020.
//  Copyright © 2020 Oleg Stasiw. All rights reserved.
//

import UIKit

extension UITextField {
    func placeholderColor(_ color: UIColor){
        var placeholderText = ""
        if self.placeholder != nil{
            placeholderText = self.placeholder!
        }
        self.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor : color])
    }
}
