//
//  DesignableTextField.swift
//  HaHaApp
//
//  Created by Atirek Pothiwala on 30/05/18.
//  Copyright © 2018 Atirek Pothiwala. All rights reserved.
//

import UIKit
@IBDesignable class DesignableTextField : UITextField {
    
    private var __maxLengths = [UITextField: Int]()
    
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 20 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    
    @objc func fix(textField: UITextField) {
        if let t = textField.text {
            textField.text = String(t.prefix(maxLength))
        }
    }
    
    @IBInspectable var borderWidth : CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor : UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var cornerRadius : CGFloat = 0.0 {
        didSet {
            self.clipsToBounds = true
            self.layer.cornerRadius = cornerRadius
        }
    }

    @IBInspectable var paddingHorizontally : CGFloat = 10.0 {
        didSet {
            self.clipsToBounds = true
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var placeHolderColor : UIColor = UIColor.lightText {
        didSet {
            self.attributedPlaceholder = NSAttributedString.init(string: self.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: placeHolderColor])
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: self.paddingHorizontally, bottom: 0, right: self.paddingHorizontally))
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: self.paddingHorizontally, bottom: 0, right: self.paddingHorizontally))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: self.paddingHorizontally, bottom: 0, right: self.paddingHorizontally))
    }

}

