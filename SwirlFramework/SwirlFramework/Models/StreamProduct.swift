import Foundation
import ObjectMapper

struct StreamProduct : Mappable, Hashable {
    
	var product_id : String?
    var product_name : String?
	var product_user : String?
	var product_title : String?
    var product_price : String?
    var product_sell_price : String?
    var product_img_url: String?
    var product_slug_url : String?
    var product_url : String?
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
        self.product_url = ""
        self.external_links = ""
        self.product_desc = ""
        self.images = ""
        self.subdomain = ""
    }
    
	init?(map: Map) {
        
	}

	mutating func mapping(map: Map) {

		product_id <- map["product_id"]
		product_user <- map["product_user"]
        product_name <- map["product_name"]
		product_title <- map["product_title"]
        product_price <- map["product_price"]
        product_sell_price <- map["product_sell_price"]
        product_slug_url <- map["product_slug_url"]
        product_url <- map["product_url"]
        product_img_url <- map["product_img_url"]
        external_links <- map["external_links"]
        product_desc <- map["product_desc"]
		images <- map["images"]
        subdomain <- map["subdomain"]
	}

}
