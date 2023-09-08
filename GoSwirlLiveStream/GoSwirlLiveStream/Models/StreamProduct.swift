import Foundation


struct StreamProduct : Hashable {
    
	var product_id : String?
    var product_name : String?
	var product_user : String?
	var product_title : String?
    var product_price : String?
    var product_sell_price : String?
    var product_img_url: String?
    var product_slug_url : String?
    var external_links : String?
    var product_desc : String?
	var images : String?
    var subdomain : String?
    
    init() {
        
        self.product_id = ""
        self.product_name = ""
        self.product_user = ""
        self.product_title = ""
        self.product_price = ""
        self.product_sell_price = ""
        self.product_img_url = ""
        self.product_slug_url = ""
        self.external_links = ""
        self.product_desc = ""
        self.images = ""
        self.subdomain = ""
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
        self.external_links = ""
        self.product_desc = ""
        self.images = ""
        self.subdomain = ""
        
        self.product_id = (jsonDataDict.object(forKey: "product_id") as? String) ?? ""
        self.product_name = (jsonDataDict.object(forKey: "product_name") as? String) ?? ""
        self.product_user = (jsonDataDict.object(forKey: "product_user") as? String) ?? ""
        self.product_title = (jsonDataDict.object(forKey: "product_title") as? String) ?? ""
        self.product_price = (jsonDataDict.object(forKey: "product_id") as? String) ?? ""
        self.product_sell_price = (jsonDataDict.object(forKey: "product_name") as? String) ?? ""
        self.product_img_url = (jsonDataDict.object(forKey: "product_user") as? String) ?? ""
        self.product_slug_url = (jsonDataDict.object(forKey: "product_title") as? String) ?? ""
        self.external_links = (jsonDataDict.object(forKey: "product_id") as? String) ?? ""
        self.product_desc = (jsonDataDict.object(forKey: "product_name") as? String) ?? ""
        self.images = (jsonDataDict.object(forKey: "product_user") as? String) ?? ""
        self.subdomain = (jsonDataDict.object(forKey: "product_title") as? String) ?? ""
    }
}
