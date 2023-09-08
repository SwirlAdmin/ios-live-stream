//
//  Products.swift
//  InStore Console
//
//  Created by A.Live Mind on 31/12/20.
//  Copyright © 2020 GetNatty. All rights reserved.
//

import Foundation

struct ProductsData {
    
    var arrayOfProducts: [Products] = []
}

extension ProductsData {
    
    init(jsonData: NSArray) {
        
        for singleDict in jsonData {
            let singleDict = Products(jsonDataDict: singleDict as! NSDictionary)
            self.arrayOfProducts.append(singleDict)
        }
    }
}

struct Products {

    var product_id : String?
    var product_user : String?
    var product_name : String?
    var product_price : String?
    var product_slug_url : String?
    var product_img_url: String?
    var product_sell_price : String?
    var product_title: String?
    var images: String?
    
    init() {
        
        self.product_id = ""
        self.product_user = ""
        self.product_name = ""
        self.product_price = ""
        self.product_slug_url = ""
        self.product_img_url = ""
        self.product_sell_price = ""
        self.product_title = ""
        self.images = ""
    }
    
    init(jsonDataDict: NSDictionary) {
        
        self.product_id = ""
        self.product_name = ""
        self.product_user = ""
        self.product_title = ""
        self.product_price = ""
        self.product_sell_price = ""
        self.product_img_url = ""
        self.product_slug_url = ""
        self.images = ""
        
        
        self.product_id = (jsonDataDict.object(forKey: "product_id") as? String) ?? ""
        self.product_name = (jsonDataDict.object(forKey: "product_name") as? String) ?? ""
        self.product_user = (jsonDataDict.object(forKey: "product_user") as? String) ?? ""
        self.product_title = (jsonDataDict.object(forKey: "product_title") as? String) ?? ""
        self.product_price = (jsonDataDict.object(forKey: "product_id") as? String) ?? ""
        self.product_sell_price = (jsonDataDict.object(forKey: "product_name") as? String) ?? ""
        self.product_img_url = (jsonDataDict.object(forKey: "product_user") as? String) ?? ""
        self.product_slug_url = (jsonDataDict.object(forKey: "product_title") as? String) ?? ""
        self.images = (jsonDataDict.object(forKey: "product_user") as? String) ?? ""
        
    }
}
