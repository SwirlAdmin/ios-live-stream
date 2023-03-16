//
//  JoinLiveViewController.swift
//  SwirlFramework
//
//  Created by Pinkesh Gajjar on 08/08/22.
//

import UIKit
import Foundation
import IQKeyboardManagerSwift
import AVFoundation
import AVKit
import Firebase
import ObjectMapper
import SwiftyJSON

class JoinLiveViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var viewPinLastComment: UIView!
    @IBOutlet weak var viewLastComment: UIView!
    @IBOutlet weak var viewAlphaLastComment: UIView!
    @IBOutlet weak var lblLastComment: UILabel!
    @IBOutlet weak var viewPinComment: UIView!
    @IBOutlet weak var viewAlphaPinComment: UIView!
    @IBOutlet weak var lblPinComment: UILabel!
    @IBOutlet weak var csBottomAlphaBottom: NSLayoutConstraint!
    @IBOutlet weak var csBottomButtonBottom: NSLayoutConstraint!
    @IBOutlet weak var csBottomButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var csBottomStackBottom: NSLayoutConstraint!//8
    
    @IBOutlet weak var viewProductList: UIView!
    @IBOutlet weak var viewAskQuestion: UIView!
    @IBOutlet weak var viewShowMe: UIView!
    @IBOutlet weak var viewLiveChat: UIView!
    @IBOutlet weak var btnCloseLiveShow: DesignableButton!
    @IBOutlet weak var btnMute: DesignableButton!
    @IBOutlet weak var imgViewMute: UIImageView!
    @IBOutlet weak var btnShareLink: DesignableButton!
    @IBOutlet weak var viewMainVideo: UIView!
    @IBOutlet weak var viewBottomButton: DesignableView!
    @IBOutlet weak var viewBottomAlpha: UIView!
    
    @IBOutlet weak var tableViewProductList: UITableView!
    @IBOutlet weak var tableViewAskQuestion: UITableView!
    @IBOutlet weak var tableViewShowMe: UITableView!
    @IBOutlet weak var tableViewComment: UITableView!
    
    @IBOutlet weak var btnCloseProductListView: DesignableButton!
    @IBOutlet weak var lblProductListTitle: UILabel!
    @IBOutlet weak var btnCloseAskQueView: DesignableButton!
    @IBOutlet weak var lblAskQueTitle: UILabel!
    @IBOutlet weak var btnCloseShowMeView: DesignableButton!
    @IBOutlet weak var lblShowMeTitle: UILabel!
    @IBOutlet weak var btnCloseLiveChatView: DesignableButton!
    @IBOutlet weak var lblLiveChatTitle: UILabel!
    @IBOutlet weak var btnSendMessage: DesignableButton!
    @IBOutlet weak var tfSendMessage: DesignableTextField!
    
    @IBOutlet weak var viewLiveStatus: DesignableView!
    @IBOutlet weak var btnProductList: MIBadgeButton!
    @IBOutlet weak var btnAskQuestion: MIBadgeButton!
    @IBOutlet weak var btnShowMe: MIBadgeButton!
    @IBOutlet weak var btnShowChat: DesignableButton!
    @IBOutlet weak var btnLike: MIBadgeButton!
    
    @IBOutlet weak var viewScheduleLive: UIView!
    @IBOutlet weak var txtViewAskQuestion: DesignableTextView!
    @IBOutlet weak var btnSend: DesignableButton!
    
    @IBOutlet weak var imgViewThumbnail: DesignableImageView!
    @IBOutlet weak var lblLiveStreamTitle: UILabel!
    @IBOutlet weak var lblLiveStreamis: UILabel!
    @IBOutlet weak var lblStartingSoon: UILabel!
    @IBOutlet weak var lblTimeDate: UILabel!
    @IBOutlet weak var viewFloater: Floater!
    @IBOutlet weak var imgViewLike: UIImageView!
    
    
    let databaseCollectionForMessage = Firestore.firestore().collection("messages")
    let databaseCollectionForLiveStream = Firestore.firestore().collection("live_streams")
    var connectorJoinLiveView: Connection?
    
    var comments = [Comment].init()
    var arrayOfTempComment = [Comment].init()
    var arrayOfSelectedProduct = [StreamProduct].init()
    var isCommentFound: Bool = false
    var isShowMeFound: Bool = false
    var isChatViewOpened: Bool = false
    var isAskQueViewOpened: Bool = false
    var isProductViewOpened: Bool = false
    var isProductListUpdate: Bool = false
    var isSessionLive: Bool = false
    
    var messageCount: Int = 0
    var likeCount: Int = 0
    
    var player: AVPlayer?
    var playerController = AVPlayerViewController()
    var urlString: String = ""
    var streamId: String = ""
    
    var latestMessage: String = ""
    var latestPinComment: String = ""
    var latestPinFrom: String = ""
    var pinCommentId: String = ""
    var shareLink: String = ""
    
    var objectOfLiveStream: LiveStream?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        Constants.setStartWithFirstVC(false)
        self.imgViewLike.isHidden = true
        self.viewScheduleLive.isHidden = false
        self.setUpView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.imgViewLike.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.setVideoMute()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name ("NotificationIdentifier"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name ("NotificationPrevious"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name ("NotificationLiveStreamClose"), object: nil)
        Constants.setJoinViewSelected(false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.setVideoMute()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        
        if touch?.view != self.viewProductList {
            self.viewProductList.isHidden = true
            self.isProductViewOpened = false
        }
        
        if touch?.view != self.viewAskQuestion {
            self.viewAskQuestion.isHidden = true
            self.isAskQueViewOpened = false
        }
        
        if touch?.view != self.viewShowMe {
            self.viewShowMe.isHidden = true
            self.isShowMeFound = false
        }
        
        if touch?.view != self.viewLiveChat {
            self.viewLiveChat.isHidden = true
            self.isChatViewOpened = false
        }
    }
    
    func setVideoMute() {
        
        if self.player != nil {
            DispatchQueue.main.async {
                self.player?.replaceCurrentItem(with: nil)
                self.player?.rate = 0
                self.player?.volume = 0
                self.playerController.player = nil
            }
        }
    }
    
    @IBAction func btnClose(_ sender: UIButton) {
        
        self.dismiss(animated: true)
    }
    
    func setUpView() {
        
        NotificationCenter.default.addObserver(self,selector:#selector(liveStreamSelected(_:)),
                         name: NSNotification.Name ("NotificationIdentifier"), object: nil)
        NotificationCenter.default.addObserver(self,selector:#selector(previousLiveStreamSelected(_:)),
                         name: NSNotification.Name ("NotificationPrevious"), object: nil)
        NotificationCenter.default.addObserver(self,selector:#selector(liveStreamClose(_:)),
                         name: NSNotification.Name ("NotificationLiveStreamClose"), object: nil)
        
        self.viewProductList.isHidden = true
        self.viewShowMe.isHidden = true
        self.viewAskQuestion.isHidden = true
        self.viewLiveChat.isHidden = true
        self.setUpTableView()
        self.updateConstraint()
    }
    
    func setUpScheduleCoverView() {
        
        self.imgViewThumbnail.loadImage(imageUrl: self.objectOfLiveStream?.user_profile, placeHolder: "photo", isCache: true, contentMode: .scaleAspectFill)
        
        if let title = self.objectOfLiveStream?.title, title != "" {
            self.lblLiveStreamTitle.text = title
        } else{
            self.lblLiveStreamTitle.text = "---"
        }
        
        let tempDateTime = self.objectOfLiveStream?.starting_time
        if tempDateTime != nil && tempDateTime != "" {
            let splitStringArray = tempDateTime!.split(separator: " ", maxSplits: 1).map(String.init)
            if splitStringArray.count > 1 {
                let tempDate = Utils.getFormatDate(date: splitStringArray[0], fromFormat: "yyyy-MM-dd", toFormat: "MMM dd, yyyy")
                let tempTime = splitStringArray[1]
                let tempDateTime = "Date : " + tempDate + " | Time : " + tempTime
                self.lblTimeDate.text = tempDateTime
            }
        }
    }
    
    func updateConstraint() {
        
        self.csBottomButtonHeight.constant = Constants.deviceWidth / 9.3
        if UIDevice.current.hasNotch {
            //self.csCloseSessionTop.constant = 55
            self.csBottomAlphaBottom.constant = -5
            self.csBottomButtonBottom.constant = -5
            self.csBottomStackBottom.constant = 24
            self.viewBottomAlpha.alpha = 0.2
        } else {
            //self.csCloseSessionTop.constant = 28
            self.csBottomAlphaBottom.constant = 0
            self.csBottomButtonBottom.constant = 0
            self.csBottomStackBottom.constant = 8
            self.viewBottomAlpha.alpha = 0.7
        }
    }
    
    func fetchProductData() {
        
        self.connectorJoinLiveView = Connection.init(TAG: "product_list", view: self.view, myProtocol: self)
        self.connectorJoinLiveView?.jsonEncoding(enable: false)
        self.connectorJoinLiveView?.requestPost(connectionUrl: Constants.product_list, params: [
            "brand_id": Constants.getUserBrandId(),
            "stream_id": self.streamId
        ])
    }
    
    @objc func liveStreamClose(_ notification: Notification) {
        
//        let alert = UIAlertController(title: "Live Stream", message: "Live Stream close soon ...", preferredStyle: .alert)
//        self.present(alert, animated: true, completion: nil)
//        let when = DispatchTime.now() + 5
//        DispatchQueue.main.asyncAfter(deadline: when) {
//            alert.dismiss(animated: true, completion: nil)
//        }
        
        //print("From JoinLiveVC liveStreamClose")
        Constants.setHeartLikeStatus(false)
        Constants.setLiveStreamId(streamId: "")
        let whenClose = DispatchTime.now() + 20
        DispatchQueue.main.asyncAfter(deadline: whenClose) {
            //self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true)
        }
    }
    
    @objc func previousLiveStreamSelected(_ notification: Notification) {
        
        //print("From previousLiveStreamSelected ...")
        self.viewLiveStatus.isHidden = false
        let discTemp = notification.userInfo?["userInfo"] as? [String: Any]
        //let id = discTemp?["userID"] as? Int ?? 0
        
        self.objectOfLiveStream = discTemp?["object"] as? LiveStream
        let tempStreamId = objectOfLiveStream?.stream_id ?? ""
        let tempURLString = objectOfLiveStream?.recording_url ?? ""
        let tempArrayOfProduct = objectOfLiveStream?.products ?? []
        _ = objectOfLiveStream?.currency_name
        let tempCurrency = objectOfLiveStream?.currency_name ?? ""
        self.setCurrencySymbol(userCurrencyName: tempCurrency)
        self.shareLink = objectOfLiveStream?.streamURL ?? ""
        
        if tempStreamId != "" {
            self.streamId = tempStreamId
            self.fetchCommentData(streamId: self.streamId)
            self.fetchPinCommentId(streamId: self.streamId)
            self.fetchProductUpdateList(streamId: self.streamId)
        }
        
        if tempURLString != "" {
            self.viewScheduleLive.isHidden = true
            self.urlString = tempURLString
            self.playVideo(videoUrl: urlString)
        }
        
        if tempArrayOfProduct.count > 0 {
            self.arrayOfSelectedProduct = tempArrayOfProduct
            self.tableViewProductList.reloadData()
            self.setProductCounterBadge()
        }
    }
    
    @objc func liveStreamSelected(_ notification: Notification) {

        print("From liveStreamSelected ...")
        //print("From liveStreamSelected 1")
        self.viewLiveStatus.isHidden = false
        //print(notification.userInfo?["userInfo"] as? [String: Any] ?? [:])
        let discTemp = notification.userInfo?["userInfo"] as? [String: Any]
        //let id = discTemp?["userID"] as? Int ?? 0
        self.objectOfLiveStream = discTemp?["object"] as? LiveStream
        let tempStreamId = objectOfLiveStream?.stream_id ?? ""
        let tempURLString = objectOfLiveStream?.mogi_accessurl ?? ""
        let tempArrayOfProduct = objectOfLiveStream?.products ?? []
        let tempCurrency = objectOfLiveStream?.currency_name ?? ""
        self.setCurrencySymbol(userCurrencyName: tempCurrency)
        self.shareLink = objectOfLiveStream?.streamURL ?? ""
        
        if tempStreamId != "" {
            //print("From liveStreamSelected 2")
            self.streamId = tempStreamId
            self.fetchCommentData(streamId: self.streamId)
            self.fetchPinCommentId(streamId: self.streamId)
            self.fetchProductUpdateList(streamId: self.streamId)
        }
        
        if tempURLString != "" {
            //print("From liveStreamSelected 3")
            self.urlString = tempURLString
        }
        
        if objectOfLiveStream?.is_Live == true {
            self.fetchProductData()
            self.playVideo(videoUrl: urlString)
            self.viewScheduleLive.isHidden = true
        } else {
            //print("From liveStreamSelected 4")
            self.viewScheduleLive.isHidden = false
        }
        
        if tempArrayOfProduct.count > 0 {
            self.arrayOfSelectedProduct = tempArrayOfProduct
            self.tableViewProductList.reloadData()
            self.setProductCounterBadge()
        }
        
        self.setUpScheduleCoverView()
    }
    
    func setCurrencySymbol(userCurrencyName: String) {
        
        let userCurrencySymbol = Utils.getSymbolForCurrencyCode(code: String(userCurrencyName.prefix(3)))
        if let currencySymbol = userCurrencySymbol {
            Constants.setUserCurrency(stringSymbol: currencySymbol)
            Constants.setUserCurrencyName(stringSymbol: String(userCurrencyName.prefix(3)))
        }
    }
    
    func setCurrentPinCommentView() {
        
        if UIDevice.current.hasNotch {
            self.viewAlphaPinComment.alpha = 0.8
        } else {
            self.viewAlphaPinComment.alpha = 1
        }
    }
    
    func showCurrentAndPinComment() {
        
        self.setCurrentPinCommentView()
        self.viewPinLastComment.isHidden = false
        let latestComment = self.arrayOfTempComment.last
        
        if latestComment != nil {
            let replyFrom = latestComment?.name ?? ""
            let message = latestComment?.message ?? ""
            self.displayAttributedString(replyFrom: replyFrom, message: message.trim(), replyFromSize: 12, messageSize: 12, label: self.lblLastComment)
            self.viewLastComment.isHidden = false
        } else {
            self.viewLastComment.isHidden = true
        }
        
        if self.latestPinComment != "" {
            self.viewPinComment.isHidden = false
            self.displayAttributedString(replyFrom: self.latestPinFrom, message: self.latestPinComment.trim(), replyFromSize: 12, messageSize: 12, label: self.lblPinComment)
        } else {
            self.viewPinComment.isHidden = true
        }
        
        if self.viewPinComment.isHidden && self.viewLastComment.isHidden {
            self.viewPinLastComment.isHidden = true
        }
    }
    
    func displayAttributedString(replyFrom: String, message: String, replyFromSize: Int, messageSize: Int, label: UILabel) {
        
        let normalText = " : " + message
        let attrsSimple = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: CGFloat(messageSize))]
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: CGFloat(replyFromSize))]
        let boldUserName = NSMutableAttributedString(string: replyFrom, attributes:attrs)
        let normalString = NSMutableAttributedString(string: normalText, attributes:attrsSimple)
        let attributedString = NSMutableAttributedString(attributedString: boldUserName)
        attributedString.append(normalString)
        label.attributedText = attributedString
    }
    
    func setVideoPlayer() {
        
        
    }
    
    func playVideo(videoUrl: String) {
        
        //print("From playVideo 1")
        let videoURL = NSURL(string: videoUrl)
        player = AVPlayer(url: videoURL! as URL)
        let playerController = AVPlayerViewController()
        playerController.player = player
        playerController.showsPlaybackControls = true
        self.addChild(playerController)
        playerController.view.frame = self.viewMainVideo.frame
        self.viewMainVideo.addSubview(playerController.view)
        player?.play()
    }
    
    func setUpTableView() {
        
        self.tableViewComment.delegate = self
        self.tableViewComment.dataSource = self
        self.tableViewComment.tableFooterView = UIView.init()
        self.tableViewComment.isHidden = true
        
        self.tableViewProductList.delegate = self
        self.tableViewProductList.dataSource = self
        self.tableViewProductList.tableFooterView = UIView(frame: .zero)
    }
    
    func addCommentData(data: [String:Any]) {
        
        var singleComment = Comment()
        singleComment.user_phone = data["user_phone"] as? String
        singleComment.profile = data["profile"] as? String
        singleComment.type = data["type"] as? String
        singleComment.is_designer = data["is_designer"] as? Bool
        singleComment.is_designer_seen = data["is_designer_seen"] as? Bool
        //singleComment.flag = data["flag"] as? String
        singleComment.title = data["title"] as? String
        singleComment.name = data["name"] as? String
        singleComment.message = data["message"] as? String
        singleComment.from = data["from"] as? String
        singleComment.cover_img = data["cover_img"] as? String
        singleComment.created_time = data["created_time"] as? Int
        self.comments.append(singleComment)
    }
    
    func deleteCommentData(data: [String:Any]) {
        
        var singleComment = Comment()
        singleComment.user_phone = data["user_phone"] as? String
        singleComment.profile = data["profile"] as? String
        singleComment.type = data["type"] as? String
        singleComment.is_designer = data["is_designer"] as? Bool
        singleComment.is_designer_seen = data["is_designer_seen"] as? Bool
        //singleComment.flag = data["flag"] as? String
        singleComment.title = data["title"] as? String
        singleComment.name = data["name"] as? String
        singleComment.message = data["message"] as? String
        singleComment.from = data["from"] as? String
        singleComment.cover_img = data["cover_img"] as? String
        singleComment.created_time = data["created_time"] as? Int
        let deleteCommentIndex = self.comments.firstIndex { $0 == singleComment} ?? 0
        self.comments.remove(at: deleteCommentIndex)
    }
    
    func fetchPicCommentData(documentId: String, streamId: String) {
        
        let docRef = self.databaseCollectionForMessage.document(streamId).collection("messages").document(documentId)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                let tempDataDesc = dataDescription
                let pinComment = tempDataDesc?["message"] as? String
                let pinFrom = tempDataDesc?["name"] as? String
                self.latestPinComment = pinComment ?? ""
                self.latestPinFrom = pinFrom ?? ""
            } else {
                self.latestPinComment = ""
            }
            self.showCurrentAndPinComment()
        }
    }
    
    func fetchPinCommentId(streamId: String) {
        
        self.databaseCollectionForLiveStream.document(streamId).addSnapshotListener { querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                self.latestPinComment = ""
                self.showCurrentAndPinComment()
                return
            }
            
            guard let data = snapshot.data() else {
                print("Document data was empty.")
                self.latestPinComment = ""
                self.showCurrentAndPinComment()
                return
            }
            
            self.pinCommentId = data["pin_comment_id"] as? String ?? ""
            let isLive = data["is_live"] as? Bool ?? false
            print("From Check Live Status 1 ", isLive)
            
//            if Constants.getLiveStreamStatus() {
//                if isLive == false {
//                    print("From Check Live Status 2 ", isLive)
//                    Constants.setLiveStreamStatus(false)
//                    Constants.setHeartLikeStatus(false)
//                    Constants.setLiveStreamId(streamId: "")
//                    let whenClose = DispatchTime.now() + 20
//                    DispatchQueue.main.asyncAfter(deadline: whenClose) {
//                        self.navigationController?.popViewController(animated: true)
//                    }
//                }
//            }
            
            if isLive {
                if Constants.getLiveStreamStatus() == false {
                    Constants.setLiveStreamStatus(true)
                    if self.isSessionLive == false {
                        self.updateLiveSession()
                    }
                }
            }
            
//            if isLive && self.isSessionLive == false {
//                self.updateLiveSession()
//            }
            
            if self.pinCommentId != "" {
                self.fetchPicCommentData(documentId: self.pinCommentId, streamId: streamId)
            } else {
                self.latestPinComment = ""
                self.showCurrentAndPinComment()
            }
        }
    }
    
    func updateLiveSession() {
        
        print("From updateLiveSession ...")
        self.isSessionLive = true
        let when = DispatchTime.now() + 15
        DispatchQueue.main.asyncAfter(deadline: when) {
            print("From updateLiveSession : ", self.urlString)
            self.viewScheduleLive.isHidden = true
            self.playVideo(videoUrl: self.urlString)
        }
    }
    
    func fetchProductUpdateList(streamId: String) {
        
        self.databaseCollectionForLiveStream.document(streamId).addSnapshotListener { querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            guard let data = snapshot.data() else {
                print("Document data was empty.")
                return
            }
            
            self.isProductListUpdate = data["product_status"] as? Bool ?? false
            print("From fetchProductUpdateList : ", self.isProductListUpdate)
            if self.isProductListUpdate {
                self.fetchProductData()
            }
        }
    }
    
    func updateHeartCountData(counter: Int, fieldName: String) {
        
        let tempCounter = counter + 1
        let docRef = self.databaseCollectionForLiveStream.document(self.streamId)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if fieldName == "heart_like" {
                    Constants.setHeartLikeStatus(true)
                }
                document.reference.updateData([
                    fieldName: tempCounter
                ])
            } else {
                
            }
        }
    }
    
    func addNewFieldToFireStore(fieldName: String) {
        
        print("From addNewFieldToFireStore : ", fieldName)
        let docRef = self.databaseCollectionForLiveStream.document(self.streamId)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if fieldName == "heart_like" {
                    Constants.setHeartLikeStatus(true)
                }
                document.reference.setData([
                    fieldName: 1
                ], merge: true)
            } else {
                self.likeCount = 0
            }
        }
    }
    
    func fetchHeartCountData() {
        
        let docRef = self.databaseCollectionForLiveStream.document(self.streamId)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                let tempDataDesc = dataDescription
                let heartCounter = tempDataDesc?["heart_like"] as? Int ?? 0
                let isHeartLikeStored = Constants.getHeartLikeStatus()
                if isHeartLikeStored == false {
                    if heartCounter <= 0 {
                        self.addNewFieldToFireStore(fieldName: "heart_like")
                    } else {
                        self.updateHeartCountData(counter: heartCounter, fieldName: "heart_like")
                    }
                }
            } else {
                
            }
        }
    }
    
    func fetchAskQueCountData() {
        
        let docRef = self.databaseCollectionForLiveStream.document(self.streamId)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                let tempDataDesc = dataDescription
                
                let askQueCounterInt = tempDataDesc?["ask_que_count"] as? Int ?? 0
                print("From askQueCounterInt : ", askQueCounterInt)
                self.updateHeartCountData(counter: askQueCounterInt, fieldName: "ask_que_count")
                
            } else {
                
            }
        }
    }
    
    func fetchCommentData(streamId: String) {
        
        //self.databaseCollectionForMessage.document(streamId).collection("messages").order(by: "created_time")
        //self.databaseCollectionForMessage.document(streamId).collection("messages").whereField("type", isEqualTo: "text")
        self.databaseCollectionForMessage.document(streamId).collection("messages").order(by: "created_time")
        .addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            print("From fetchCommentData count : ", snapshot.count)
            
            if snapshot.count > 0 {
                self.isCommentFound = true
                if snapshot.documents.count > 0 {
                    if snapshot.documentChanges.count > 0 {
                        snapshot.documentChanges.forEach { diff in
                            if (diff.type == .added) {
                                self.addCommentData(data: diff.document.data())
                                print("From Added Comment Data : ",diff.document.data())
                            }
                            if (diff.type == .modified) {
                                //self.comments.append(diff.document.data())
                                print("From Modified Comment Data : ",diff.document.data())
                            }
                            if (diff.type == .removed) {
                                print("From comment document removed : \(diff.document.data())")
                                self.deleteCommentData(data: diff.document.data())
                                self.showCurrentAndPinComment()
                                self.tableViewComment.reloadData()
                            }
                        }
                    }
                }
            } else {
                self.isCommentFound = false
                self.deleteAllComment()
            }
            
            //self.arrayOfTempComment = Array(self.comments.reversed())
            self.arrayOfTempComment = Array(self.comments)
            if self.arrayOfTempComment.count > 0 {
                print("From Last Message : ", self.arrayOfTempComment.first as Any)
                self.showCurrentAndPinComment()
                self.tableViewComment.isHidden = false
                
            }
        
            self.tableViewComment.reloadData()
            
            if self.arrayOfTempComment.count > 0 {
                self.tableViewScrollBottom()
            }
        }
    }
    
    func deleteAllComment() {
        
        if self.isCommentFound == false {
            self.comments = []
            self.arrayOfTempComment = []
            self.latestPinComment = ""
            self.showCurrentAndPinComment()
            self.tableViewComment.reloadData()
        }
        
//        if self.isCommentFound == false && self.isShowMeFound == true {
//
//            self.comments = self.comments.filter({ $0.type != "text" })
//            self.tableViewComment.reloadData()
//        }
//
//        if self.isCommentFound == true && self.isShowMeFound == false {
//
//            self.comments = self.comments.filter({ $0.type != "other" })
//            self.tableViewComment.reloadData()
//        }
    }
    
    func tableViewScrollBottom() {
        
        UIView.animate(withDuration: 0.2, delay: 0.1, options: .transitionFlipFromBottom, animations: {
            self.tableViewComment.reloadData()
            if self.arrayOfTempComment.count > 0 {
                self.tableViewComment.scrollToBottom(isAnimated: false)
            }
        }, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.tfSendMessage {
           
        }
    }
    
    func hideAndShowView(showView: UIView) {
        
        self.viewShowMe.isHidden = true
        self.viewLiveChat.isHidden = true
        self.viewAskQuestion.isHidden = true
        self.viewProductList.isHidden = true
        
        //showView.animShow(viewColor: UIColor.white)
        showView.isHidden = false
    }
    
    func setProductCounterBadge() {
        
        print("From setProductCounterBadge : ", self.arrayOfSelectedProduct.count)
        if self.arrayOfSelectedProduct.count > 0 {
            self.btnProductList.badgeBackgroundColor = UIColor.init(hex: "#613FC0")
            self.btnProductList.badgeTextColor = UIColor(named: "colorWhite") ?? .white
            self.btnProductList.badgeString = String(self.arrayOfSelectedProduct.count)
        } else {
            self.btnProductList.badgeTextColor = UIColor.clear
            self.btnProductList.badgeBackgroundColor = UIColor.clear
        }
    }
    
    @IBAction func btnSend(_ sender: UIButton) {
        
        let tfMessage = self.txtViewAskQuestion.text!
        if tfMessage.isEmpty {
            popSnackBar(message: "Enter your text.")
            return
        }

        self.connectorJoinLiveView = Connection.init(TAG: "ask_question", view: self.view, myProtocol: self)
        self.connectorJoinLiveView?.jsonEncoding(enable: false)
        self.connectorJoinLiveView?.requestPost(connectionUrl: Constants.ask_question, params: [
            "brand_id": Constants.getUserBrandId(),
            "stream_id": self.streamId,
            "query": tfMessage,
            "name": Constants.getUserName(),
            "mobile": Constants.getUserMobile()
        ])
    }
    
    @IBAction func btnProductList(_ sender: UIButton) {
        
        if self.arrayOfSelectedProduct.count > 0 {
            if self.isProductViewOpened {
                self.viewProductList.isHidden = true
            } else {
                self.hideAndShowView(showView: self.viewProductList)
            }
            self.isProductViewOpened = !self.isProductViewOpened
        } else {
            popSnackBar(message: "No Product Found ...")
//            let alert = UIAlertController(title: "", message: "No Product Found ...!", preferredStyle: .alert)
//            self.present(alert, animated: true, completion: nil)
//            let when = DispatchTime.now() + 2
//            DispatchQueue.main.asyncAfter(deadline: when){
//              alert.dismiss(animated: true, completion: nil)
//            }
        }
    }
    
    @IBAction func btnAskQuestion(_ sender: UIButton) {
        
        if self.isAskQueViewOpened {
            self.viewAskQuestion.isHidden = true
        } else {
            self.hideAndShowView(showView: self.viewAskQuestion)
        }
        self.isAskQueViewOpened = !self.isAskQueViewOpened
    }
    
    @IBAction func btnShowMe(_ sender: UIButton) {
        
        self.hideAndShowView(showView: self.viewShowMe)
        self.isShowMeFound = !self.isShowMeFound
    }
    
    @IBAction func btnShowChat(_ sender: UIButton) {
        
        if self.isChatViewOpened {
            self.viewLiveChat.isHidden = true
        } else {
            self.hideAndShowView(showView: self.viewLiveChat)
        }
        
        self.isChatViewOpened = !self.isChatViewOpened
    }
    
    @IBAction func btnLike(_ sender: UIButton) {
        
        self.fetchHeartCountData()
        self.viewFloater.startAnimation()
        self.btnLike.isEnabled = false
        self.btnLike.isHidden = true
        self.imgViewLike.isHidden = false
        let when = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.viewFloater.stopAnimation()
            self.btnLike.isEnabled = true
            //self.imgViewLike.isHidden = true
            self.btnLike.isHidden = false
            //self.btnLike.isHidden = false
            //self.imgViewMute.image = UIImage(named: "mute", in: Bundle(identifier: "com.goswirl.SwirlFramework"), compatibleWith: nil)
            self.btnLike.setImage(UIImage(named: "", in: Bundle(identifier: "com.goswirl.SwirlFramework"), compatibleWith: nil), for: .normal)
        }
    }
    
    @IBAction func btnMute(_ sender: UIButton) {
        
        if sender.isSelected {
            player?.isMuted = false
            self.imgViewMute.image = UIImage(named: "unmute", in: Bundle(identifier: "com.goswirl.SwirlFramework"), compatibleWith: nil)
        } else {
            player?.isMuted = true
            self.imgViewMute.image = UIImage(named: "mute", in: Bundle(identifier: "com.goswirl.SwirlFramework"), compatibleWith: nil)
        }
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func btnShareLink(_ sender: UIButton) {
        
        if self.shareLink != "" {
            let items = [shareLink]
            let ac = UIActivityViewController(activityItems: items as [Any], applicationActivities: nil)
            present(ac, animated: true)
        } else {
            popSnackBar(message: "Share Link not found")
        }
        
//        if let stringURL = self.labelShareMyStore.text {
//            let items = [stringURL]
//            let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
//            present(ac, animated: true)
//        } else {
//            let alert = UIAlertController(title: "", message: "No link available ..!", preferredStyle: .alert)
//            self.present(alert, animated: true, completion: nil)
//            let when = DispatchTime.now() + 2
//            DispatchQueue.main.asyncAfter(deadline: when){
//              alert.dismiss(animated: true, completion: nil)
//            }
//        }
    }
    
    @IBAction func btnCloseLiveShow(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true)
    }
    
    @IBAction func btnCloseProductListView(_ sender: UIButton) {
        
        self.viewProductList.isHidden = true
        self.isProductViewOpened = false
    }
    
    @IBAction func btnCloseAskQueView(_ sender: UIButton) {
        
        self.viewAskQuestion.isHidden = true
        self.isAskQueViewOpened = false
    }
    
    func hideAskQuestion() {
        
        self.viewAskQuestion.isHidden = true
        self.txtViewAskQuestion.text = ""
        self.txtViewAskQuestion.refresh()
    }
    
    @IBAction func btnCloseShowMeView(_ sender: UIButton) {
        
        self.viewShowMe.isHidden = true
    }
    
    @IBAction func btnCloseLiveChatView(_ sender: UIButton) {
        
        self.viewLiveChat.isHidden = true
        self.isChatViewOpened = false
    }
    
    func createDocument() {
        
        self.databaseCollectionForMessage.document(self.streamId).setData([
            "stream_id": self.streamId
        ])
    }
    
    @IBAction func btnSendMessage(_ sender: UIButton) {
        
        self.dismissKeyboard()
        guard let message = self.tfSendMessage.text, !message.isEmpty else {
            return
        }
        
        self.messageCount = self.messageCount + 1
        self.createDocument()
        let currntTime = Int(NSDate().timeIntervalSince1970 * 1000)
        let fullName = "SDK Tester"
        self.databaseCollectionForMessage.document(self.streamId).collection("messages").addDocument(data: [
            "from": "SDK Tester",
            "message": message,
            "type": "text",
            "created_time":currntTime,
            "is_designer": true,
            "is_user": false,
            "name": fullName,
            "profile": Constants.getUserDetails(key: "profile"),
            "user_phone": Constants.getUserDetails(key: "user_phone"),
            "is_designer_seen": true,
            "is_user_seen": true,
            "cover_img": "",
            "title": Constants.liveNowTitle,
            "index": self.messageCount
        ])
        self.tfSendMessage.text = nil
    }
}

extension JoinLiveViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.tableViewComment {
            return self.arrayOfTempComment.count
        } else {
            return self.arrayOfSelectedProduct.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tableViewComment {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
            let comment = self.arrayOfTempComment[indexPath.row]
            let replyFrom = comment.name
            let message = comment.message
            
            let normalText = " : " + (message?.trim() ?? "")
            let attrsSimple = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)]
            let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
            let boldUserName = NSMutableAttributedString(string: replyFrom!, attributes:attrs)
            let normalString = NSMutableAttributedString(string: normalText, attributes:attrsSimple)
            let attributedString = NSMutableAttributedString(attributedString: boldUserName)
            attributedString.append(normalString)
            cell.lblMessage.attributedText = attributedString
            cell.lblMessage.textColor = UIColor.black
            cell.viewLblMessage.alpha = 1
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AttachProductTableViewCell", for: indexPath) as! AttachProductTableViewCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.objectOfStreamProduct = self.arrayOfSelectedProduct[indexPath.row]
            cell.configCell()
            cell.delegate = self
            return cell
        }
    }
}

extension JoinLiveViewController: ConnectionProtocol {
    
    func Success(TAG: String, json: String, data: Data?) {
        
        let jsonData = JSON.init(parseJSON: json)
        if let isSuccess = jsonData["success"].bool, isSuccess {
            let data = jsonData["data"]
            print("From Product JSON Data : ", data)
            if let message = jsonData["message"].string {
                if message == "Ask Question sent successfully" {
                    popSnackBar(message: message)
                    self.hideAskQuestion()
                    self.fetchAskQueCountData()
                }
            }
            if let message = jsonData["message"].string {
                if message == "all product listing" {
                    let data = jsonData["data"]
                    self.prepareProductList(jsonData: data)
                }
            }
        } else {
            if let message = jsonData["message"].string {
                popSnackBar(message: message)
            }
        }
    }
    
    func prepareProductList(jsonData: JSON) {
        
        if let json = jsonData["products"].rawString(), let array = Mapper<StreamProduct>().mapArray(JSONString: json) {
            if array.count > 0 {
                self.arrayOfSelectedProduct = []
                self.arrayOfSelectedProduct = array
            } else {
                self.arrayOfSelectedProduct = []
            }
            self.tableViewProductList.reloadData()
        }
        
        self.setProductCounterBadge()
    }
    
    func Failure(TAG: String, error: String) {
        
        popSnackBar(message: error)
    }
    
    func NoConnection(TAG: String) {
        
        popSnackBar(message: Constants.noInternet)
    }
    
    func popSnackBar(message: String) {
        
        Utils.popSnackBar(containerView: self.view, message: message)
    }
}

extension JoinLiveViewController: AttachProductDelegate {
    
    func shareProductLink(stringProductLink: String) {
        
        print("From stringProductLink : ", stringProductLink)
        
        if let url = URL(string: stringProductLink), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    func deleteProduct(productObject: StreamProduct) {
        
    }
}
