//
//  AttachProductTableViewCell.swift
//  InStore Console
//
//  Created by A.Live Mind on 19/10/21.
//  Copyright © 2021 GetNatty. All rights reserved.
//

import UIKit

protocol AttachProductDelegate {
    func shareProductLink(stringProductLink: String)
    func deleteProduct(productObject: StreamProduct)
}

class AttachProductTableViewCell: UITableViewCell {

    @IBOutlet weak var imgViewProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var lblProductDiscountPrice: UILabel!
    @IBOutlet weak var btnShareLink: DesignableButton!
    @IBOutlet weak var btnDeleteProduct: DesignableButton!
    @IBOutlet weak var btnBuyNow: DesignableButton!
    
    var objectOfStreamProduct: StreamProduct?
    var delegate: AttachProductDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configCell() {
        
        if self.objectOfStreamProduct?.product_img_url != "" && self.objectOfStreamProduct?.product_img_url != nil {
            self.imgViewProduct.loadImage(imageUrl: objectOfStreamProduct?.product_img_url, placeHolder: "ph_swirl", isCache: true, contentMode: .scaleAspectFill)
        } else if self.objectOfStreamProduct?.images != "" && self.objectOfStreamProduct?.images != nil {
            self.imgViewProduct.loadImage(imageUrl: objectOfStreamProduct?.images, placeHolder: "ph_swirl", isCache: true, contentMode: .scaleAspectFill)
        }
        
        if self.objectOfStreamProduct?.product_title != nil {
            self.lblProductName.text = self.objectOfStreamProduct?.product_title
        } else if self.objectOfStreamProduct?.product_name != nil {
            self.lblProductName.text = self.objectOfStreamProduct?.product_name
        } else {
            self.lblProductName.text = "---"
        }
        
        if let price = self.objectOfStreamProduct?.product_price {
            if let discountPrice = self.objectOfStreamProduct?.product_sell_price {
                let intPrice = Int(price) ?? 0
                let intDiscountPrice = Int(discountPrice) ?? 0
                if intDiscountPrice < intPrice {
                    self.lblProductDiscountPrice.isHidden = false
                    let originalPrice = Constants.getUserCurrency() + "" + price
                    let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: originalPrice)
                        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))
                    self.lblProductDiscountPrice.attributedText = attributeString
                    self.lblProductPrice.text = Constants.getUserCurrency() + "" + discountPrice
                } else {
                    self.lblProductDiscountPrice.isHidden = true
                    self.lblProductPrice.text = Constants.getUserCurrency() + "" + price
                }
            } else {
                self.lblProductDiscountPrice.isHidden = true
                self.lblProductPrice.text = Constants.getUserCurrency() + "" + price
            }
        } else {
            self.lblProductDiscountPrice.isHidden = true
            self.lblProductPrice.text = Constants.getUserCurrency() + " 0"
        }
        
//        if self.objectOfStreamProduct?.product_price != nil {
//            self.lblProductPrice.text = Constants.getUserCurrency() + " " + (self.objectOfStreamProduct?.product_price)!
//        } else {
//            self.lblProductPrice.text = Constants.getUserCurrency() + " 0"
//        }
//
//        if self.objectOfStreamProduct?.product_sell_price != nil {
//            self.lblProductDiscountPrice.isHidden = false
//            self.lblProductDiscountPrice.text = Constants.getUserCurrency() + " " + (self.objectOfStreamProduct?.product_sell_price)!
//        } else {
//            self.lblProductDiscountPrice.text = Constants.getUserCurrency() + " 0"
//            self.lblProductDiscountPrice.isHidden = true
//        }
    }
    
    @IBAction func btnShareLink(_ sender: UIButton) {
        
        if objectOfStreamProduct?.product_slug_url != nil {
            self.delegate.shareProductLink(stringProductLink: (objectOfStreamProduct?.product_slug_url)!)
        } else {
            self.delegate.shareProductLink(stringProductLink: "")
        }
    }
    
    @IBAction func btnDeleteProduct(_ sender: UIButton) {
        
        if objectOfStreamProduct != nil {
            self.delegate.deleteProduct(productObject: objectOfStreamProduct!)
        }
    }
    
    @IBAction func btnBuyNow(_ sender: UIButton) {
        
//        if objectOfStreamProduct?.product_url != nil {
//            self.delegate.shareProductLink(stringProductLink: (objectOfStreamProduct?.product_url)!)
//        } else {
//            self.delegate.shareProductLink(stringProductLink: "")
//        }
        //print("From Selected Product : ", objectOfStreamProduct as Any)
        if objectOfStreamProduct?.product_id != nil {
            self.delegate.shareProductLink(stringProductLink: (objectOfStreamProduct?.product_id)!)
        } else {
            self.delegate.shareProductLink(stringProductLink: "")
        }
    }
    
}
