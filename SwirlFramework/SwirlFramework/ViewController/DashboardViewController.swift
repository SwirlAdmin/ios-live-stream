//
//  DashboardViewController.swift
//  AnalyticFramework
//
//  Created by Pinkesh Gajjar on 05/08/22.
//  Copyright © 2022 ProgrammingWithSwift. All rights reserved.
//

import UIKit
//import Firebase
import IQKeyboardManagerSwift
import ObjectMapper
import SwiftyJSON
import AVKit

public protocol SwirlDelegate {
    
    func getProductId(productId: String)
}

public class DashboardViewController: UIViewController {
    
    
    //var databaseCollectionForLiveStream = Firestore.firestore().collection("live_streams")
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        //print("From viewDidLoad Video,FetchData,LiveStatus : ", Constants.getDisplayVideoStatus(), Constants.getFetchDataStatus(), Constants.getLiveStreamStatus())
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //self.navigationController?.navigationBar.isHidden = true
    }
}
    
    
