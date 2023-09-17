//
//  RecentLiveStream.swift
//  InStore Console
//
//  Created by A.Live Mind on 30/12/20.
//  Copyright © 2020 GetNatty. All rights reserved.
//

import Foundation

struct LiveStreamsData {
    
    var arrayOfLiveStreams: [LiveStreams] = []
}

extension LiveStreamsData {
    
    init(jsonData: NSArray) {
        
        //let videoDictArray = jsonData["all_video"] as! NSArray
        for singleDict in jsonData {
            let singleDict = LiveStreams(jsonDataDict: singleDict as! NSDictionary)
            self.arrayOfLiveStreams.append(singleDict)
        }
        
        //print("From LiveStreamsData : ", self.arrayOfLiveStreams)
    }
}


struct LiveStreams {

    var stream_id: String?
    var designer_id: String?
    var title : String?
    var cover_img : String?
    var recording_url : String?
    var mogi_accessurl: String?
    var product_ids: String?
    var products: [StreamProduct]?
    var starting_time: String?
    var ending_time : String?
    var is_schedule : String?
    var stream_platform: String?
    var status : String?
    var is_defer : String?
    var banner_url : String?
    var banner_content_color : String?
    var pin_comment: String?
    var user_profile: String?
    var designer_brand_name : String?
    var subdomain : String?
    var streamURL: String?
    var currency_name: String?
    var duration_time: String?
    var is_Live: Bool?
    
    init() {
        
        self.stream_id = ""
        self.designer_id = ""
        self.title = ""
        self.cover_img = ""
        self.recording_url = ""
        self.mogi_accessurl = ""
        self.product_ids = ""
        self.starting_time = ""
        self.ending_time = ""
        self.is_schedule = ""
        self.stream_platform = ""
        self.status = ""
        self.is_defer = ""
        self.banner_url = ""
        self.banner_content_color = ""
        self.pin_comment = ""
        self.user_profile = ""
        self.designer_brand_name = ""
        self.subdomain = ""
        self.streamURL = ""
        self.currency_name = ""
        self.duration_time = ""
        self.is_Live = false
        self.products = [StreamProduct].init()
    }
    
    init(jsonDataDict: NSDictionary) {
        
        self.stream_id = ""
        self.designer_id = ""
        self.title = ""
        self.cover_img = ""
        self.recording_url = ""
        self.mogi_accessurl = ""
        self.product_ids = ""
        self.starting_time = ""
        self.ending_time = ""
        self.is_schedule = ""
        self.stream_platform = ""
        self.status = ""
        self.is_defer = ""
        self.banner_url = ""
        self.banner_content_color = ""
        self.pin_comment = ""
        self.user_profile = ""
        self.designer_brand_name = ""
        self.subdomain = ""
        self.streamURL = ""
        self.currency_name = ""
        self.duration_time = ""
        self.is_Live = false
        self.products = [StreamProduct].init()
        
        self.stream_id = (jsonDataDict.object(forKey: "streram_id") as? String) ?? ""
        self.designer_id = (jsonDataDict.object(forKey: "designer_id") as? String) ?? ""
        self.title = (jsonDataDict.object(forKey: "title") as? String) ?? ""
        self.cover_img = (jsonDataDict.object(forKey: "cover_img") as? String) ?? ""
        self.recording_url = (jsonDataDict.object(forKey: "recording_url") as? String) ?? ""
        self.mogi_accessurl = (jsonDataDict.object(forKey: "mogi_accessurl") as? String) ?? ""
        self.product_ids = (jsonDataDict.object(forKey: "product_ids") as? String) ?? ""
        self.starting_time = (jsonDataDict.object(forKey: "starting_time") as? String) ?? ""
        self.ending_time = (jsonDataDict.object(forKey: "ending_time") as? String) ?? ""
        self.is_schedule = (jsonDataDict.object(forKey: "is_schedule") as? String) ?? ""
        self.stream_platform = (jsonDataDict.object(forKey: "stream_platform") as? String) ?? ""
        self.status = (jsonDataDict.object(forKey: "status") as? String) ?? ""
        
        self.is_defer = (jsonDataDict.object(forKey: "is_defer") as? String) ?? ""
        self.banner_url = (jsonDataDict.object(forKey: "banner_url") as? String) ?? ""
        self.banner_content_color = (jsonDataDict.object(forKey: "banner_content_color") as? String) ?? ""
        self.pin_comment = (jsonDataDict.object(forKey: "pin_comment") as? String) ?? ""
        self.user_profile = (jsonDataDict.object(forKey: "user_profile") as? String) ?? ""
        
        let arrayOfProduct = jsonDataDict.object(forKey: "products") as? NSArray
        
        var objectOfProduct: StreamProductData? = nil
        
        if arrayOfProduct != nil && arrayOfProduct!.count > 0 {
            objectOfProduct = StreamProductData(jsonData: arrayOfProduct!)
        }
        
        self.products = objectOfProduct?.arrayOfProducts
        
        self.subdomain = (jsonDataDict.object(forKey: "subdomain") as? String) ?? ""
        self.streamURL = (jsonDataDict.object(forKey: "streamURL") as? String) ?? ""
        self.currency_name = (jsonDataDict.object(forKey: "currency_name") as? String) ?? ""
        self.duration_time = (jsonDataDict.object(forKey: "duration_time") as? String) ?? ""
    }
}

