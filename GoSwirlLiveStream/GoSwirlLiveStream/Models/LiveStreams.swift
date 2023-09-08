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

    var ask_que_count: String?
    var audios: String?
    var cover_img : String?
    var created_date : String?
    var date : String?
    var deep_link: String?
    var designer_brand_name: String?
    var designer_id : String?
    var designer_name : String?
    var designer_profile: String?
    var ending_time : String?
    var go_live: String?
    var id : String?
    var is_live: Bool?
    var is_recorded: Bool?
    var is_schedule: String?
    var modified_date : String?
    var products : [Products]?
    var product_ids: String?
    var showmes : String?
    var starting_time: String?
    var duration_time: String?
    var streram_id: String?
    var stream_platform: String?
    var title: String?
    var total_messages : String?
    var user_ids : [String]?
    var user_percentage: String?
    var user_profile: String?
    var view_count : String?
    var current_date: String?
    var ivs_stream_key: String?
    var mux_stream_key: String?
    var ivs_rtmp_url: String?
    var recording_url: String?
    var mux_rtmp_url: String?
    var is_test: String?
    
    init() {
        self.user_ids = [String].init()
        self.is_live = false
        self.is_recorded = false
        self.ask_que_count = ""
        self.date = ""
        self.id = ""
        self.designer_name = ""
        self.designer_profile = ""
        self.streram_id = ""
        self.designer_id = ""
        self.title = ""
        self.cover_img = ""
        self.product_ids = ""
        self.starting_time = ""
        self.duration_time = ""
        self.ending_time = ""
        self.is_schedule = ""
        self.view_count = ""
        self.showmes = ""
        self.audios = ""
        self.total_messages = ""
        self.created_date = ""
        self.modified_date = ""
        self.user_profile = ""
        self.user_percentage = ""
        self.designer_brand_name = ""
        self.current_date = ""
        self.go_live = ""
        self.deep_link = ""
        self.ivs_stream_key = ""
        self.mux_stream_key = ""
        self.ivs_rtmp_url = ""
        self.recording_url = ""
        self.products = [Products].init()
        self.stream_platform = ""
        self.mux_rtmp_url = ""
        self.is_test = ""
    }
    
    init(jsonDataDict: NSDictionary) {
        
        self.user_ids = [String].init()
        self.is_live = false
        self.is_recorded = false
        self.ask_que_count = ""
        self.date = ""
        self.id = ""
        self.designer_name = ""
        self.designer_profile = ""
        self.streram_id = ""
        self.designer_id = ""
        self.title = ""
        self.cover_img = ""
        self.product_ids = ""
        self.starting_time = ""
        self.duration_time = ""
        self.ending_time = ""
        self.is_schedule = ""
        self.view_count = ""
        self.showmes = ""
        self.audios = ""
        self.total_messages = ""
        self.created_date = ""
        self.modified_date = ""
        self.user_profile = ""
        self.user_percentage = ""
        self.designer_brand_name = ""
        self.current_date = ""
        self.go_live = ""
        self.deep_link = ""
        self.ivs_stream_key = ""
        self.mux_stream_key = ""
        self.ivs_rtmp_url = ""
        self.recording_url = ""
        self.products = [Products].init()
        self.stream_platform = ""
        self.mux_rtmp_url = ""
        self.is_test = ""
        
        self.ask_que_count = (jsonDataDict.object(forKey: "product_id") as? String) ?? ""
        self.audios = (jsonDataDict.object(forKey: "product_name") as? String) ?? ""
        self.cover_img = (jsonDataDict.object(forKey: "cover_img") as? String) ?? ""
        self.created_date = (jsonDataDict.object(forKey: "created_date") as? String) ?? ""
        self.date = (jsonDataDict.object(forKey: "product_id") as? String) ?? ""
        self.deep_link = (jsonDataDict.object(forKey: "deep_link") as? String) ?? ""
        self.designer_brand_name = (jsonDataDict.object(forKey: "designer_brand_name") as? String) ?? ""
        self.designer_id = (jsonDataDict.object(forKey: "designer_id") as? String) ?? ""
        self.designer_name = (jsonDataDict.object(forKey: "product_id") as? String) ?? ""
        self.designer_profile = (jsonDataDict.object(forKey: "product_name") as? String) ?? ""
        self.ending_time = (jsonDataDict.object(forKey: "ending_time") as? String) ?? ""
        self.go_live = (jsonDataDict.object(forKey: "product_title") as? String) ?? ""
        
        self.id = (jsonDataDict.object(forKey: "id") as? String) ?? ""
        self.is_live = (jsonDataDict.object(forKey: "product_name") as? Bool) ?? false
        self.is_recorded = (jsonDataDict.object(forKey: "product_user") as? Bool) ?? false
        self.is_schedule = (jsonDataDict.object(forKey: "is_schedule") as? String) ?? ""
        self.modified_date = (jsonDataDict.object(forKey: "product_id") as? String) ?? ""
        //self.productsDict = (jsonDataDict.object(forKey: "products") as? NSArray) ?? NSArray()
        //print("From Data2 : ", jsonDataDict.object(forKey: "products") as? NSArray)
        let arrayOfProduct = jsonDataDict.object(forKey: "products") as? NSArray
        
        var objectOfProduct: ProductsData? = nil
        
        if arrayOfProduct != nil && arrayOfProduct!.count > 0 {
            objectOfProduct = ProductsData(jsonData: arrayOfProduct!)
        }
        
        self.products = objectOfProduct?.arrayOfProducts
        self.product_ids = (jsonDataDict.object(forKey: "product_ids") as? String) ?? ""
        self.showmes = (jsonDataDict.object(forKey: "product_title") as? String) ?? ""
        self.starting_time = (jsonDataDict.object(forKey: "starting_time") as? String) ?? ""
        self.duration_time = (jsonDataDict.object(forKey: "duration_time") as? String) ?? ""
        self.streram_id = (jsonDataDict.object(forKey: "streram_id") as? String) ?? ""
        self.stream_platform = (jsonDataDict.object(forKey: "stream_platform") as? String) ?? ""
        self.title = (jsonDataDict.object(forKey: "title") as? String) ?? ""
        
        self.total_messages = (jsonDataDict.object(forKey: "product_id") as? String) ?? ""
        self.user_ids = (jsonDataDict.object(forKey: "product_name") as? [String]) ?? [String].init()
        self.user_percentage = (jsonDataDict.object(forKey: "product_user") as? String) ?? ""
        self.user_profile = (jsonDataDict.object(forKey: "user_profile") as? String) ?? ""
        self.view_count = (jsonDataDict.object(forKey: "product_id") as? String) ?? ""
        self.current_date = (jsonDataDict.object(forKey: "current_date") as? String) ?? ""
        self.ivs_stream_key = (jsonDataDict.object(forKey: "ivs_stream_key") as? String) ?? ""
        self.mux_stream_key = (jsonDataDict.object(forKey: "product_id") as? String) ?? ""
        self.ivs_rtmp_url = (jsonDataDict.object(forKey: "product_name") as? String) ?? ""
        self.recording_url = (jsonDataDict.object(forKey: "recording_url") as? String) ?? ""
        self.mux_rtmp_url = (jsonDataDict.object(forKey: "product_title") as? String) ?? ""
        self.is_test = (jsonDataDict.object(forKey: "is_test") as? String) ?? ""
    }
}

