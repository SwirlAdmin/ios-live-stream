//
//  DashboardViewController.swift
//  AnalyticFramework
//
//  Created by Pinkesh Gajjar on 05/08/22.
//  Copyright © 2022 ProgrammingWithSwift. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift
import ObjectMapper
import SwiftyJSON
import AVKit

public protocol SwirlDelegate {
    
    func getProductId(productId: String)
}

public class DashboardViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var collectionViewLiveStream: UICollectionView!
    @IBOutlet weak var csCVLiveStream: NSLayoutConstraint!//215
    @IBOutlet weak var collectionViewPrevious: UICollectionView!
    @IBOutlet weak var csCVPreviousHeight: NSLayoutConstraint!//215
    
    @IBOutlet weak var csBottomStackBottom: NSLayoutConstraint!//8
    @IBOutlet weak var csBottomButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var csPinLCAlphaBottom: NSLayoutConstraint!
    @IBOutlet weak var csPinLCViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var viewUpcomingLabel: UIView!
    @IBOutlet weak var viewCCUpcomingLiveStream: UIView!
    @IBOutlet weak var viewUpcomingNotFound: UIView!
    @IBOutlet weak var lblUpcomingTitle: UILabel!
    @IBOutlet weak var lblUpcomingNotFound: UILabel!
    
    @IBOutlet weak var viewPreviousLabel: UIView!
    @IBOutlet weak var viewCCPreviousLiveStream: UIView!
    @IBOutlet weak var viewPreviousNotFound: UIView!
    @IBOutlet weak var lblPreviousTitle: UILabel!
    @IBOutlet weak var lblPreviousNotFound: UILabel!
    @IBOutlet weak var indicatorMain: UIActivityIndicatorView!
    @IBOutlet weak var viewMainListing: UIView!
    @IBOutlet weak var viewMainVideo: UIView!
    @IBOutlet weak var viewStreamVideo: UIView!
    @IBOutlet weak var viewBottomAlpha: UIView!
    @IBOutlet weak var viewBottomButton: DesignableView!
    @IBOutlet weak var btnCloseLiveStream: DesignableButton!
    @IBOutlet weak var btnShareLink: DesignableButton!
    @IBOutlet weak var btnMute: DesignableButton!
    @IBOutlet weak var viewMuteButton: UIView!
    @IBOutlet weak var viewLiveStatus: DesignableView!
    @IBOutlet weak var lblLiveStatus: UILabel!
    @IBOutlet weak var viewPinLastComment: UIView!
    @IBOutlet weak var viewProductList: UIView!
    @IBOutlet weak var viewAskQuestion: UIView!
    @IBOutlet weak var viewLiveChat: UIView!
    @IBOutlet weak var viewFloater: Floater!
    @IBOutlet weak var btnProductList: MIBadgeButton!
    @IBOutlet weak var btnAskQuestion: MIBadgeButton!
    @IBOutlet weak var btnLike: MIBadgeButton!
    @IBOutlet weak var imgViewLike: UIImageView!
    @IBOutlet weak var imgViewMute: UIImageView!
    @IBOutlet weak var viewLastComment: UIView!
    @IBOutlet weak var viewAlphaLastComment: UIView!
    @IBOutlet weak var lblLastComment: UILabel!
    @IBOutlet weak var btnShowChat: DesignableButton!
    @IBOutlet weak var viewPinComment: UIView!
    @IBOutlet weak var viewAlphaPinComment: UIView!
    @IBOutlet weak var lblPinComment: UILabel!
    @IBOutlet weak var lblProductTitle: UILabel!
    @IBOutlet weak var tableViewProductList: UITableView!
    @IBOutlet weak var tableViewLiveChat: UITableView!
    @IBOutlet weak var lblAskQuestionTitle: UILabel!
    @IBOutlet weak var txtViewAskQuestion: DesignableTextView!
    @IBOutlet weak var btnSendQuestion: DesignableButton!
    @IBOutlet weak var btnCloseLiveChatView: DesignableButton!
    @IBOutlet weak var lblLiveChatTitle: UILabel!
    @IBOutlet weak var btnSendMessage: DesignableButton!
    @IBOutlet weak var tfSendMessage: DesignableTextField!
    @IBOutlet weak var csCloseBtnTop: NSLayoutConstraint!//25
    @IBOutlet weak var cdHeaderViewHeight: NSLayoutConstraint!//64
    
    @IBOutlet weak var viewCoverImage: UIView!
    
    @IBOutlet weak var imgViewThumbnail: DesignableImageView!
    @IBOutlet weak var lblStreamTitle: UILabel!
    @IBOutlet weak var lblLiveStream: UILabel!
    @IBOutlet weak var lblStartingSoon: UILabel!
    @IBOutlet weak var lblTimeAndTime: UILabel!
    
    @IBOutlet weak var viewLiveChatChild: UIView!
    @IBOutlet weak var viewLiveChatSeprator: UIView!
    @IBOutlet weak var viewMainSendMsgTF: UIView!
    @IBOutlet weak var viewSendMsgTF: DesignableView!
    
    
    public static var isAlreadyLaunchedOnce = false
    private static var isAlreadyFetchData = false
    
    public var brandId: String = ""
    public var userName: String = ""
    public var mobileNumber: String = ""
    
    var latestPinComment: String = ""
    var latestPinFrom: String = ""
    var pinCommentId: String = ""
    var shareLink: String = ""
    var tempUrl: String = ""
    var tempPinCommentUrl: String = ""
    
    public var liveStreamIndex: Int = 0
    var messageCount: Int = 0
    
    var isCommentFound: Bool = false
    public var navigationBarColor: String = "#613FC0"
    public var delegate: SwirlDelegate!
    
    var isProductViewOpened: Bool = false
    var isAskQueViewOpened: Bool = false
    var isChatViewOpened: Bool = false
    var isProductListUpdate: Bool = false
    
    var connectorDashboard: Connection?
    var arrayOfLiveStream = [LiveStream].init()
    var arrayOfCompletedLiveStream = [LiveStream].init()
    
    var comments = [Comment].init()
    var arrayOfTempComment = [Comment].init()
    var arrayOfSelectedProduct = [StreamProduct].init()
    
    let playerController = AVPlayerViewController()
    var player: AVPlayer?
    var objectOfLiveStream: LiveStream?
    var urlString: String = ""
    var streamId: String = ""
    
    //var databaseCollectionForLiveStream = Firestore.firestore().collection("live_streams")
    //lazy var databaseCollectionForLiveStream = Firestore.firestore().collection("live_streams")
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        //print("From viewDidLoad Video,FetchData,LiveStatus : ", Constants.getDisplayVideoStatus(), Constants.getFetchDataStatus(), Constants.getLiveStreamStatus())
        
        if DashboardViewController.isAlreadyFetchData == false {
            Constants.setDisplayVideoStatus(false)
            Constants.setFetchDataStatus(false)
            Constants.setLiveStreamStatus(false)
            DashboardViewController.isAlreadyFetchData = true
        }
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        if #available(iOS 13.0, *) {
            NotificationCenter.default.addObserver(self, selector: #selector(willEnterForegroundNotification), name: UIScene.willEnterForegroundNotification, object: nil)
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(willEnterForegroundNotification), name: UIApplication.willEnterForegroundNotification, object: nil)
        }
        
        //print("From SDK viewDidLoad ...........................................")
        
        if Constants.getLiveStreamStatus() == false {
            self.hideVideoView()
        }
        
        self.viewCoverImage.isHidden = true
        if Constants.getHeartLikeStatus() == false {
            self.imgViewLike.isHidden = true
        }
        
        self.viewMainListing.isHidden = false
        self.setUpView()
        //print("From viewDidLoad fetchLiveStreamData")
        Constants.setStartWithFirstVC(true)
        //self.clearData()
        //self.fetchLiveStreamData()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Constants.getHeartLikeStatus() == false {
            self.imgViewLike.isHidden = true
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Constants.setFetchDataStatusForPrevious(false)
        //print("From viewWillAppear Video,FetchData,FetchDataPrevious,LiveStatus : ", Constants.getDisplayVideoStatus(), Constants.getFetchDataStatus(),Constants.getLiveStreamStatus())
        
        if Constants.getFetchDataStatusForPrevious() {
            if self.streamId != "" {
                
            }
        }
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.isTranslucent = false
        self.indicatorMain.isHidden = true
        self.setUpNavigation(animated: animated)
        self.fetchLiveStreamData()
        //print("From Check Value Constants.getLiveStreamStatus() : ", Constants.getLiveStreamStatus())
        if Constants.getLiveStreamStatus() == false && Constants.getStartWithFirstVC() == false {
            //print("From viewWillAppear fetchLiveStreamData")
            //self.fetchLiveStreamData()
        }
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //self.navigationController?.navigationBar.isHidden = true
    }
    
    @objc func willEnterForegroundNotification(_ notification: Notification) {
        
        self.player?.play()
    }
    
    func clearData() {
        
        self.arrayOfLiveStream = []
        self.arrayOfCompletedLiveStream = []
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        
        if touch?.view != self.viewProductList {
            self.viewProductList.isHidden = true
            self.isProductViewOpened = false
        }
        
        if touch?.view != self.viewAskQuestion {
            self.viewAskQuestion.isHidden = true
            self.isAskQueViewOpened = false
        }
                
        if touch?.view != self.viewLiveChat && touch?.view != self.viewLiveChatChild && touch?.view != self.viewLiveChatSeprator && touch?.view != self.viewMainSendMsgTF && touch?.view != self.viewSendMsgTF {
            self.viewLiveChat.isHidden = true
            self.isChatViewOpened = false
        }
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let maxLength = 150
        
        if string.count > 1 {
            print("From shouldChangeCharactersIn 1")
            if self.checkValidURL(message: string) {
                print("From shouldChangeCharactersIn 2")
                guard let textFieldText = textField.text, let stringRange = Range(range, in: textFieldText)
                 else {
                    return false
                }

                let newTextFieldText = textFieldText
                    .replacingCharacters(in: stringRange, with: string)
                    .prefix(maxLength)
                textField.text = String(newTextFieldText)
                return false
            } else {
                print("From shouldChangeCharactersIn 3")
                guard let textFieldText = textField.text,
                    let stringRange = Range(range, in: textFieldText)
                    else {
                        return false
                    }

                    let newTextFieldText = textFieldText
                        .replacingCharacters(in: stringRange, with: string)
                        .prefix(maxLength)
                    textField.text = String(newTextFieldText)
                    return false
            }
        } else {
            let currentString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)

            return newString.count <= maxLength
        }
        //return true
    }
    
    func checkValidURL(message: String) -> Bool {
        
        let isValidUrl = self.validateURL(url: message)
        if isValidUrl {
            return true
        } else {
            let check = message.isValidUrl()
            if check {
                return true
            } else {
                return false
            }
        }
    }
    
    func validateURL(url: String) -> Bool {
        
        let regex = "http[s]?://(([^/:.[:space:]]+(.[^/:.[:space:]]+)*)|([0-9](.[0-9]{3})))(:[0-9]+)?((/[^?#[:space:]]+)([^#[:space:]]+)?(#.+)?)?"
        let test = NSPredicate(format:"SELF MATCHES %@", regex)
        let result = test.evaluate(with: url)
        return result
    }
    
    public func getBrandId(brandId: String) {
        
        self.brandId = brandId
    }
    
    func setUpView() {
        
        let bundle = Bundle(identifier: "com.goswirl.SwirlFramework")
        let plistPath = bundle?.path(forResource: "GoogleService-Info", ofType: "plist")
        //print("From SDK setUpView plistPath : ", plistPath as Any)
        if !DashboardViewController.isAlreadyLaunchedOnce {
            guard let plistPath = plistPath,
            let options =  FirebaseOptions(contentsOfFile: plistPath)
            else { return }
            if FirebaseApp.app() == nil {
                FirebaseApp.configure(options: options)
        }
            DashboardViewController.isAlreadyLaunchedOnce = true
        }
        
        if !self.userName.isEmpty {
            Constants.setUserName(userName: self.userName)
        }
        
        if !self.mobileNumber.isEmpty {
            Constants.setUserMobile(userMobile: self.mobileNumber)
        }
        
        self.viewProductList.isHidden = true
        self.viewAskQuestion.isHidden = true
        self.viewLiveChat.isHidden = true
        
        Constants.setUserBrandId(stringBrandId: self.brandId)
        
//        #if targetEnvironment(simulator)
//            print("From Simulator ..........................")
//            IQKeyboardManager.shared.enable = true
//            IQKeyboardManager.shared.toolbarBarTintColor = .white
//            IQKeyboardManager.shared.toolbarTintColor = UIColor.init(hex: "#323232")
//        #else
//        print("From Device ..........................")
//            IQKeyboardManager.shared.enable = true
//            IQKeyboardManager.shared.toolbarBarTintColor = .white
//            IQKeyboardManager.shared.toolbarTintColor = UIColor.init(hex: "#323232")
//        #endif
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarBarTintColor = .white
        IQKeyboardManager.shared.toolbarTintColor = UIColor.init(hex: "#323232")
        
        self.setUpTableView()
        self.setCollectionView()
        self.setUpStackView()
        
        self.updateConstraint()
    }
    
    @objc override func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func updateConstraint() {
        
        self.csBottomButtonHeight.constant = Constants.deviceWidth / 9.3
        if UIDevice.current.hasNotch {
            self.csPinLCViewBottom.constant = 0
            self.csPinLCAlphaBottom.constant = 0
            self.csCloseBtnTop.constant = 40
            self.cdHeaderViewHeight.constant = 92
            self.csBottomStackBottom.constant = 24
        } else {
            self.csPinLCViewBottom.constant = 0
            self.csPinLCAlphaBottom.constant = 0
            self.csCloseBtnTop.constant = 25
            self.cdHeaderViewHeight.constant = 64
            self.csBottomStackBottom.constant = 8
        }
    }
    
    func setUpTableView() {
        
        self.tableViewLiveChat.delegate = self
        self.tableViewLiveChat.dataSource = self
        self.tableViewLiveChat.tableFooterView = UIView.init()
        self.tableViewLiveChat.isHidden = true
        
        self.tableViewProductList.delegate = self
        self.tableViewProductList.dataSource = self
        self.tableViewProductList.tableFooterView = UIView(frame: .zero)
    }
    
    func hideVideoView() {
        
        DispatchQueue.main.async {
            self.viewStreamVideo.isHidden = true
            self.viewMainVideo.isHidden = true
        }
    }
    
    func fetchPinCommentId(streamId: String) {
        
        let databaseCollectionForLiveStream = Firestore.firestore().collection("live_streams")
        databaseCollectionForLiveStream.document(streamId).addSnapshotListener { querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                self.latestPinComment = ""
                self.showCurrentAndPinComment()
                return
            }
            
            guard let data = snapshot.data() else {
                //print("Document data was empty.")
                self.latestPinComment = ""
                self.showCurrentAndPinComment()
                return
            }
            
            self.pinCommentId = data["pin_comment_id"] as? String ?? ""
           
            if self.pinCommentId != "" {
                self.fetchPicCommentData(documentId: self.pinCommentId, streamId: streamId)
            } else {
                self.latestPinComment = ""
                self.showCurrentAndPinComment()
            }
        }
    }
    
    func fetchPicCommentData(documentId: String, streamId: String) {
        
        let databaseCollectionForMessage = Firestore.firestore().collection("messages")
        let docRef = databaseCollectionForMessage.document(streamId).collection("messages").document(documentId)
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
    
    func removeFetchCommentData(streamId: String) {
        
        let databaseCollectionForMessage = Firestore.firestore().collection("messages")
        let temp = databaseCollectionForMessage.document(streamId).collection("messages")
            .addSnapshotListener { querySnapshot, error in
                guard querySnapshot != nil else {
                    print("Error fetching snapshots: \(error!)")
                    return
                }
            }
        
        temp.remove()
    }
    
    func fetchCommentData(streamId: String) {
        
        Constants.setFetchDataStatus(true)
        let databaseCollectionForMessage = Firestore.firestore().collection("messages")
        databaseCollectionForMessage.document(streamId).collection("messages").order(by: "created_time")
        .addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            if snapshot.count > 0 {
                self.isCommentFound = true
                if snapshot.documents.count > 0 {
                    if snapshot.documentChanges.count > 0 {
                        snapshot.documentChanges.forEach { diff in
                            if (diff.type == .added) {
                                self.addCommentData(data: diff.document.data())
                                //print("From Added Comment Data : ",diff.document.data())
                            }
                            if (diff.type == .modified) {
                                //self.comments.append(diff.document.data())
                                print("From Modified Comment Data : ",diff.document.data())
                            }
                            if (diff.type == .removed) {
                                print("From comment document removed : \(diff.document.data())")
                                self.deleteCommentData(data: diff.document.data())
                                self.showCurrentAndPinComment()
                                self.tableViewLiveChat.reloadData()
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
                //print("From Last Message : ", self.arrayOfTempComment.first as Any)
                self.showCurrentAndPinComment()
                self.tableViewLiveChat.isHidden = false
                
            }
        
            let when = DispatchTime.now() + 5
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.tableViewLiveChat.reloadData()
            }
            
            if self.arrayOfTempComment.count > 0 {
                DispatchQueue.main.asyncAfter(deadline: when) {
                    self.tableViewScrollBottom()
                }
            }
        }
    }
    
    func tableViewScrollBottom() {
        
        UIView.animate(withDuration: 0.2, delay: 0.1, options: .transitionFlipFromBottom, animations: {
            self.tableViewLiveChat.reloadData()
            if self.arrayOfTempComment.count > 0 {
                self.tableViewLiveChat.scrollToBottom(isAnimated: false)
            }
        }, completion: nil)
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
            let isUrl = self.checkValidURL(message: self.latestPinComment.trim())
            if isUrl {
                self.tempPinCommentUrl = self.latestPinComment.trim()
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapFunctionPinComment))
                self.lblPinComment.isUserInteractionEnabled = true
                self.lblPinComment.addGestureRecognizer(tap)
                self.lblPinComment.numberOfLines = 2
            } else {
                self.lblPinComment.numberOfLines = 0
            }
        } else {
            self.viewPinComment.isHidden = true
        }
        
        if self.viewPinComment.isHidden && self.viewLastComment.isHidden {
            self.viewPinLastComment.isHidden = true
        }
    }
    
    @IBAction func tapFunctionPinComment(sender: UITapGestureRecognizer) {
        
        if let url = URL(string: self.tempPinCommentUrl), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
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
    
    func setCurrentPinCommentView() {
        
        if UIDevice.current.hasNotch {
            self.viewAlphaPinComment.alpha = 0.8
        } else {
            self.viewAlphaPinComment.alpha = 1
        }
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
        self.arrayOfTempComment = Array(self.comments)
    }
    
    func deleteAllComment() {
        
        if self.isCommentFound == false {
            self.comments = []
            self.arrayOfTempComment = []
            self.latestPinComment = ""
            self.showCurrentAndPinComment()
            self.tableViewLiveChat.reloadData()
        }
    }
    
    func fetchLiveStreamStatus(streamId: String) {

        let databaseCollectionForLiveStream = Firestore.firestore().collection("live_streams")
        databaseCollectionForLiveStream.document(streamId).addSnapshotListener { querySnapshot, error in

            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }

            guard let data = snapshot.data() else {
                print("Document data was empty.")
                return
            }
            
            let index = self.arrayOfLiveStream.firstIndex { $0.stream_id == streamId }
            if index != nil {
                self.liveStreamIndex = index ?? 0
                let checkLiveStatus = data["is_live"] as? Bool ?? false
                if checkLiveStatus == true {
                    Constants.setLiveStreamId(streamId: streamId)
                    self.arrayOfLiveStream[index!].is_Live = true
                    self.shareLink = self.arrayOfLiveStream[index!].streamURL ?? ""
                    self.arrayOfLiveStream.sort { $0.is_Live == true && $1.is_Live == false }
                    let when = DispatchTime.now() + 15
                    DispatchQueue.main.asyncAfter(deadline: when) {
                        if Constants.getFetchDataStatus() == false {
                            self.fetchCommentData(streamId: streamId)
                            self.fetchPinCommentId(streamId: streamId)
                            self.fetchProductUpdateList(streamId: streamId)
                            Constants.setfetchLiveStreamStatus(true)
                        }
                        
                        Constants.setLiveStreamStatus(true)
                        self.collectionViewLiveStream.reloadData()
                        if Constants.getLiveButtonClickStatus() == true {
                            self.showVideoViewFirst()
                            //self.showVideoView()
                        }
                    }
                } else {
                    self.liveStreamCloseNotification(streamId: streamId)
                }
            }
            
            if Constants.getLiveStreamStatus() == true {
                if Constants.getJoinViewSelected() == false {
                    self.collectionViewLiveStream.reloadData()
                    self.scrollToFirstCell()
                }
            }
        }
    }
    
    func liveStreamCloseNotification(streamId: String) {
        
        //print("From liveStreamCloseNotification 1 ...")
        if streamId == Constants.getLiveStreamId() {
            //print("From liveStreamCloseNotification : ", streamId, Constants.getLiveStreamId())
            Constants.setLiveStreamId(streamId: "")
            Constants.setDisplayVideoStatus(false)
            //self.fetchLiveStreamData()
            
            let when = DispatchTime.now() + 20
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.arrayOfLiveStream[self.liveStreamIndex].is_Live = false
                //print("From liveStreamCloseNotification 3 : ", streamId, Constants.getLiveStreamId())
                DispatchQueue.main.async {
                    //print("From liveStreamCloseNotification 2 ...")
                    Constants.setLiveStreamStatus(false)
                    Constants.setFetchDataStatus(false)
                    Constants.setDisplayVideoStatus(false)
                    Constants.setHeartLikeStatus(false)
                    self.showMainView()
                    self.arrayOfLiveStream = []
                    self.fetchLiveStreamData()
                    self.collectionViewLiveStream.reloadData()
                }
            }
        }
    }
    
    func setProductCounterBadge() {
        
        //print("From setProductCounterBadge : ", self.arrayOfSelectedProduct.count)
        if self.arrayOfSelectedProduct.count > 0 {
            self.btnProductList.badgeBackgroundColor = UIColor.init(hex: "#613FC0")
            self.btnProductList.badgeTextColor = UIColor(named: "colorWhite") ?? .white
            self.btnProductList.badgeString = String(self.arrayOfSelectedProduct.count)
        } else {
            self.btnProductList.badgeTextColor = UIColor.clear
            self.btnProductList.badgeBackgroundColor = UIColor.clear
        }
    }
    
    func fetchLiveStreamData() {
        
        //self.arrayOfLiveStream = []
        //self.arrayOfCompletedLiveStream = []
        self.indicatorMain.isHidden = false
        self.indicatorMain.startAnimating()
        //print("From fetchLiveStreamData : ", self.brandId)
        connectorDashboard = Connection.init(TAG: "dashboard_livestream", view: self.view, myProtocol: self)
        connectorDashboard?.jsonEncoding(enable: false)
        connectorDashboard?.requestPost(connectionUrl: Constants.live_schedule_stream, params: [
            "brand_id": self.brandId
        ])
    }
    
    func fetchProductData() {
        
        self.connectorDashboard = Connection.init(TAG: "product_list", view: self.view, myProtocol: self)
        self.connectorDashboard?.jsonEncoding(enable: false)
        self.connectorDashboard?.requestPost(connectionUrl: Constants.product_list, params: [
            "brand_id": Constants.getUserBrandId(),
            "stream_id": self.streamId
        ])
    }
    
    func fetchProductUpdateList(streamId: String) {
        
        let databaseCollectionForLiveStream = Firestore.firestore().collection("live_streams")
        databaseCollectionForLiveStream.document(streamId).addSnapshotListener { querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            guard let data = snapshot.data() else {
                print("Document data was empty.")
                return
            }
            
            self.isProductListUpdate = data["product_status"] as? Bool ?? false
            //print("From fetchProductUpdateList : ", self.isProductListUpdate)
            if self.isProductListUpdate {
                self.fetchProductData()
            }
        }
    }
    
    func addNewFieldToFireStore(fieldName: String) {
        
        //print("From addNewFieldToFireStore : ", fieldName)
        let databaseCollectionForLiveStream = Firestore.firestore().collection("live_streams")
        let docRef = databaseCollectionForLiveStream.document(self.streamId)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if fieldName == "heart_like" {
                    Constants.setHeartLikeStatus(true)
                }
                document.reference.setData([
                    fieldName: 1
                ], merge: true)
            } else {
                
            }
        }
    }
    
    func updateHeartCountData(counter: Int, fieldName: String) {
        
        let tempCounter = counter + 1
        let databaseCollectionForLiveStream = Firestore.firestore().collection("live_streams")
        let docRef = databaseCollectionForLiveStream.document(self.streamId)
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
    
    func fetchHeartCountData() {
        
        let databaseCollectionForLiveStream = Firestore.firestore().collection("live_streams")
        let docRef = databaseCollectionForLiveStream.document(self.streamId)
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
        
        let databaseCollectionForLiveStream = Firestore.firestore().collection("live_streams")
        let docRef = databaseCollectionForLiveStream.document(self.streamId)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                let tempDataDesc = dataDescription
                
                let askQueCounterInt = tempDataDesc?["ask_que_count"] as? Int ?? 0
                //print("From askQueCounterInt : ", askQueCounterInt)
                self.updateHeartCountData(counter: askQueCounterInt, fieldName: "ask_que_count")
                
            } else {
                
            }
        }
    }
    
    func setUpNavigation(animated: Bool) {
        
        if #available(iOS 15, *) {
                
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(hex: self.navigationBarColor)
                
            let titleAttribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.white]
                appearance.titleTextAttributes = titleAttribute
                
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            navigationController?.navigationBar.tintColor = UIColor.white
        } else {
            
            self.navigationController?.setNavigationBarHidden(false, animated: animated)
            self.navigationController?.navigationBar.barTintColor = UIColor.red
            UINavigationBar.appearance().barTintColor = UIColor.red
        }
    }
    
    func setCollectionView() {
        
        self.collectionViewLiveStream.delegate = self
        self.collectionViewLiveStream.dataSource = self
        self.csCVLiveStream.constant = CGFloat(Constants.deviceWidth / 1.72) + 1
        
        self.collectionViewPrevious.delegate = self
        self.collectionViewPrevious.dataSource = self
        self.csCVPreviousHeight.constant = CGFloat(Constants.deviceWidth / 1.72) + 1
    }
    
    func createDocument() {
        
        let databaseCollectionForMessage = Firestore.firestore().collection("messages")
        databaseCollectionForMessage.document(self.streamId).setData([
            "stream_id": self.streamId
        ])
    }
    
    func setUpStackView() {
        
        //self.viewCCPreviousLiveStream.isHidden = true
        self.viewUpcomingNotFound.isHidden = true
        self.viewPreviousNotFound.isHidden = true
    }
    
    func playVideo(videoUrl: String) {
        
        Constants.setDisplayVideoStatus(true)
        let videoURL = NSURL(string: videoUrl)
        player = AVPlayer(url: videoURL! as URL)
        self.playerController.player = player
        self.playerController.showsPlaybackControls = false
        self.addChild(playerController)
        playerController.view.frame = self.viewStreamVideo.frame //self.viewMainVideo.frame
        self.viewStreamVideo.addSubview(playerController.view)
        player?.play()
    }
    
    func removeVideoPlayer() {
        
        if self.player != nil {
            DispatchQueue.main.async {
                self.player?.replaceCurrentItem(with: nil)
                self.player?.rate = 0
                self.player?.volume = 0
                self.playerController.player = nil
            }
        }
    }
    
    @IBAction func btnSendMessage(_ sender: UIButton) {
        
        self.dismissKeyboard()
        guard let message = self.tfSendMessage.text, !message.isEmpty else {
            popSnackBar(message: "This field is mandatory")
            return
        }
        
        if Constants.getVerifyUserStatus() == false {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle(identifier: "com.goswirl.SwirlFramework"))
            let destVC = storyboard.instantiateViewController(withIdentifier: "VerifyUserVC") as! VerifyUserVC
            destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            destVC.delegate = self
            destVC.streamId = self.streamId
            self.present(destVC, animated: true, completion: nil)
            self.view.alpha = 0.5
        } else {
            self.sendMessage(message: message)
        }
    }
    
    func sendMessage(message: String) {
        
        self.messageCount = self.messageCount + 1
        self.createDocument()
        let currntTime = Int(NSDate().timeIntervalSince1970 * 1000)
        let databaseCollectionForMessage = Firestore.firestore().collection("messages")
        databaseCollectionForMessage.document(self.streamId).collection("messages").addDocument(data: [
            "from": Constants.getUserName(),
            "message": message,
            "type": "text",
            "created_time":currntTime,
            "is_designer": true,
            "is_user": false,
            "name": Constants.getUserName(),
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
    
    @IBAction func btnCloseLiveChat(_ sender: UIButton) {
        
        self.viewLiveChat.isHidden = true
        self.isChatViewOpened = false
    }
    
    @IBAction func btnSendQuestion(_ sender: UIButton) {
        
        let tfMessage = self.txtViewAskQuestion.text!
        if tfMessage.isEmpty {
            popSnackBar(message: "Enter your text.")
            return
        }

        self.connectorDashboard = Connection.init(TAG: "ask_question", view: self.view, myProtocol: self)
        self.connectorDashboard?.jsonEncoding(enable: false)
        self.connectorDashboard?.requestPost(connectionUrl: Constants.ask_question, params: [
            "brand_id": Constants.getUserBrandId(),
            "stream_id": self.streamId,
            "query": tfMessage,
            "name": Constants.getUserName(),
            "mobile": Constants.getUserMobile()
        ])
    }
    
    @IBAction func btnCloseAskQuestion(_ sender: UIButton) {
        
        self.viewAskQuestion.isHidden = true
        self.isAskQueViewOpened = false
    }
    
    @IBAction func btnCloseProductListView(_ sender: UIButton) {
        
        self.viewProductList.isHidden = true
        self.isProductViewOpened = false
    }
    
    @IBAction func btnCloseCoverImage(_ sender: UIButton) {
        
        DispatchQueue.main.async {
            Constants.setLiveButtonClickStatus(false)
            self.navigationController?.navigationBar.isHidden = false
            self.navigationController?.navigationBar.isTranslucent = false
            self.viewCoverImage.isHidden = true
            self.collectionViewLiveStream.reloadData()
            self.viewMainListing.layoutIfNeeded()
            self.viewMainListing.layoutSubviews()
        }
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
    
    @IBAction func btnShowChat(_ sender: UIButton) {
        
        if self.isChatViewOpened {
            self.viewLiveChat.isHidden = true
        } else {
            self.hideAndShowView(showView: self.viewLiveChat)
        }
        
        self.isChatViewOpened = !self.isChatViewOpened
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
    
    @IBAction func btnCloseLiveStream(_ sender: UIButton) {
        
        Constants.setLiveButtonClickStatus(false)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.isTranslucent = false
        self.removeVideoPlayer()
        self.hideVideoView()
        self.viewMainListing.isHidden = false
        self.scrollToFirstCell()
    }
    
    @IBAction func btnShareLink(_ sender: UIButton) {
        
        if self.shareLink != "" {
            let items = [shareLink]
            let ac = UIActivityViewController(activityItems: items as [Any], applicationActivities: nil)
            present(ac, animated: true)
        } else {
            popSnackBar(message: "Share Link not found")
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
    
    func hideAndShowView(showView: UIView) {
        
        self.viewLiveChat.isHidden = true
        self.viewAskQuestion.isHidden = true
        self.viewProductList.isHidden = true
        
        //showView.animShow(viewColor: UIColor.white)
        showView.isHidden = false
    }
    
    func showCoverImageView() {
        
        self.setUpScheduleCoverView()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.isHidden = true
        self.viewMainVideo.isHidden = true
        self.viewCoverImage.isHidden = false
    }
    
    func setUpScheduleCoverView() {
        
        self.imgViewThumbnail.loadImage(imageUrl: self.objectOfLiveStream?.user_profile, placeHolder: "photo", isCache: true, contentMode: .scaleAspectFill)
        
        if let title = self.objectOfLiveStream?.title, title != "" {
            self.lblStreamTitle.text = title
        } else{
            self.lblStreamTitle.text = "---"
        }
        
        let tempDateTime = self.objectOfLiveStream?.starting_time
        if tempDateTime != nil && tempDateTime != "" {
            let splitStringArray = tempDateTime!.split(separator: " ", maxSplits: 1).map(String.init)
            if splitStringArray.count > 1 {
                let tempDate = Utils.getFormatDate(date: splitStringArray[0], fromFormat: "yyyy-MM-dd", toFormat: "MMM dd, yyyy")
                let tempTime = splitStringArray[1]
                let tempDateTime = "Date : " + tempDate + " | Time : " + tempTime
                self.lblTimeAndTime.text = tempDateTime
            }
        }
    }
    
    func showVideoViewFirst() {
        
        if Constants.getDisplayVideoStatus() == false {
            
            DispatchQueue.main.async {
                //print("From 11111111111111111111 : ", self.urlString)
                self.navigationController?.navigationBar.isTranslucent = true
                self.navigationController?.navigationBar.isHidden = true
                self.viewStreamVideo.isHidden = false
                self.viewMainVideo.isHidden = false
                self.viewCoverImage.isHidden = true
                self.viewMainListing.isHidden = true
                self.playVideo(videoUrl: self.urlString)
                Constants.setDisplayVideoStatus(true)
            }
        }
    }
    
    func showVideoView() {
        
        DispatchQueue.main.async {
            //print("From 222222222222222222222222 : ", self.urlString)
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.navigationBar.isHidden = true
            self.viewCoverImage.isHidden = true
            self.viewMainListing.isHidden = true
            self.viewStreamVideo.isHidden = false
            self.viewMainVideo.isHidden = false
            self.playVideo(videoUrl: self.urlString)
        }
    }
    
//    func playVideoView(stringUrl: String) {
//        
//        DispatchQueue.main.async {
//            //print("From 3333333333333333333 : ", stringUrl)
//            self.navigationController?.navigationBar.isTranslucent = true
//            self.navigationController?.navigationBar.isHidden = true
//            self.viewCoverImage.isHidden = true
//            self.viewMainListing.isHidden = true
//            self.viewStreamVideo.isHidden = false
//            self.viewMainVideo.isHidden = false
//            self.playVideo(videoUrl: stringUrl)
//        }
//    }
    
    func showMainView() {
        
        DispatchQueue.main.async {
            self.navigationController?.navigationBar.isHidden = false
            self.navigationController?.navigationBar.isTranslucent = false
            self.viewCoverImage.isHidden = true
            //self.viewStreamVideo.isHidden = true
            //self.viewMainVideo.isHidden = true
            let when = DispatchTime.now() + 0.5
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.viewMainListing.isHidden = false
            }
            self.removeVideoPlayer()
            Constants.setLiveButtonClickStatus(false)
        }
    }
}

extension DashboardViewController: VerifyUserVCDeleagte {
    
    func submitUserInfo() {
        
        Constants.setVerifyUserStatus(true)
        self.view.alpha = 1
        
        guard let message = self.tfSendMessage.text, !message.isEmpty else {
            return
        }
        self.sendMessage(message: message)
    }
    
    func cancelSubmition() {
        self.view.alpha = 1
    }
}

extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.collectionViewLiveStream {
            return self.arrayOfLiveStream.count
        } else if collectionView == self.collectionViewPrevious {
            return self.arrayOfCompletedLiveStream.count
        } else {
            return 5
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionViewLiveStream {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LiveStreamCollectionViewCell", for: indexPath) as! LiveStreamCollectionViewCell
            cell.tag = indexPath.row
            cell.delegate = self
            cell.btnSelectCell.tag = indexPath.row
            cell.btnShareLink.tag = indexPath.row
            cell.objectOfLiveStream = self.arrayOfLiveStream[indexPath.row]
            cell.configCell()
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PreviousStreamCollectionViewCell", for: indexPath) as! PreviousStreamCollectionViewCell
            cell.delegate = self
            cell.btnSelectCell.tag = indexPath.row
            cell.btnShareLink.tag = indexPath.row
            cell.objectOfLiveStream = self.arrayOfCompletedLiveStream[indexPath.row]
            cell.configCell()
            return cell
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = CGFloat(Constants.deviceWidth / 2.8)
        let cellHieght = CGFloat(Constants.deviceWidth / 1.72)
        return CGSize.init(width: cellWidth, height: cellHieght)
    }
}

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.tableViewLiveChat {
            return self.arrayOfTempComment.count
        } else {
            return self.arrayOfSelectedProduct.count
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tableViewLiveChat {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
            let comment = self.arrayOfTempComment[indexPath.row]
            let replyFrom = comment.name
            let message = comment.message
            let commentFrom = comment.from ?? ""
            
            let isUrl = self.checkValidURL(message: message?.trim() ?? "")
            var tempUrl = message?.trim() ?? ""
            
            if isUrl {
                let urlHasHttpPrefix = tempUrl.hasPrefix("http://")
                let urlHasHttpsPrefix = tempUrl.hasPrefix("https://")
                let validUrlString = (urlHasHttpPrefix || urlHasHttpsPrefix) ? tempUrl : "https://\(tempUrl)"
                tempUrl = validUrlString
                self.tempUrl = tempUrl
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapFunction))
                cell.lblMessage.isUserInteractionEnabled = true
                cell.lblMessage.addGestureRecognizer(tap)
                
                var tempAttrs: [NSAttributedString.Key : AnyObject] = [:]
                var tempAttr: [NSAttributedString.Key : AnyObject] = [:]
                
                if commentFrom == Constants.getUserBrandId() {
                    tempAttrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15), NSAttributedString.Key.foregroundColor : UIColor.white]
                    tempAttr = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15), NSAttributedString.Key.foregroundColor : UIColor.init(hex: "#9C8CFF")]
                } else {
                    tempAttrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15), NSAttributedString.Key.foregroundColor : UIColor.black]
                    tempAttr = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15), NSAttributedString.Key.foregroundColor : UIColor.blue]
                }
                
                let normalText = " : " + tempUrl
                //let attrsSimple = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor : UIColor.blue]
                //let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15), NSAttributedString.Key.foregroundColor : UIColor.black]
                let boldUserName = NSMutableAttributedString(string: replyFrom!, attributes:tempAttrs)
                let normalString = NSMutableAttributedString(string: normalText, attributes:tempAttr)
                let attributedString = NSMutableAttributedString(attributedString: boldUserName)
                attributedString.append(normalString)
                cell.lblMessage.attributedText = attributedString
                cell.configCellForURL(userId: commentFrom)
                //cell.lblMessage.textColor = UIColor.black
                //cell.viewLblMessage.alpha = 1
                return cell
            } else {
                let normalText = " : " + (message?.trim() ?? "")
                let attrsSimple = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)]
                let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
                let boldUserName = NSMutableAttributedString(string: replyFrom!, attributes:attrs)
                let normalString = NSMutableAttributedString(string: normalText, attributes:attrsSimple)
                let attributedString = NSMutableAttributedString(attributedString: boldUserName)
                attributedString.append(normalString)
                cell.lblMessage.attributedText = attributedString
                cell.lblMessage.textColor = UIColor.black
                cell.configCell(userId: commentFrom)
                //cell.viewLblMessage.alpha = 1
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AttachProductTableViewCell", for: indexPath) as! AttachProductTableViewCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.objectOfStreamProduct = self.arrayOfSelectedProduct[indexPath.row]
            cell.configCell()
            cell.delegate = self
            return cell
        }
    }
    
    @IBAction func tapFunction(sender: UITapGestureRecognizer) {
        
        if let url = URL(string: self.tempUrl) {
            if UIApplication.shared.canOpenURL(url) {
                //UIApplication.shared.open(url, options: [:])
                self.player?.pause()
                UIApplication.shared.open(url, completionHandler: { success in
                    if success {
                        print("From tapFunction success ")
                       DispatchQueue.main.async {
                           self.player?.play()
                       }
                    }
                 })
            }
        }
    }
}

extension DashboardViewController: PreviousCCDelegate {
    
    func btnSelectPreviousCell(index: Int) {
        
        let objectOfLiveStream = self.arrayOfCompletedLiveStream[index]
        
        let when = DispatchTime.now() + 0.1
        DispatchQueue.main.asyncAfter(deadline: when) {
            let loginResponse = ["userInfo": ["userID": index, "object": objectOfLiveStream]]
            NotificationCenter.default
                        .post(name: NSNotification.Name("NotificationPrevious"),
                         object: nil,
                         userInfo: loginResponse)
        }
    }
    
    func btnSelectShareLink(index: Int) {
        
//        let objectOfLiveStream = self.arrayOfCompletedLiveStream[index]
//        //print("From btnSelectShareLink : ", objectOfLiveStream)
//        
//        if let tempURL = objectOfLiveStream.streamURL, tempURL != "" {
//            print("From btnSelectShareLink : ", tempURL)
//            if let url = URL(string: tempURL), UIApplication.shared.canOpenURL(url) {
//                UIApplication.shared.open(url)
//            }
//        }
    }
}

extension DashboardViewController: LiveStreamCCDelegate {
    
    func btnSelectCell(index: Int) {
    
        Constants.setLiveButtonClickStatus(true)
        let objectOfLiveStream = self.arrayOfLiveStream[index]
        self.objectOfLiveStream = objectOfLiveStream
        //print("From btnSelectCell : ", Constants.getLiveStreamStatus())
        let tempStreamId = objectOfLiveStream.stream_id ?? ""
        let tempURLString = objectOfLiveStream.mogi_accessurl ?? ""
        
        if tempURLString != "" {
            //print("From liveStreamSelected 3")
            self.urlString = tempURLString
        }
        
        if tempStreamId != "" {
            self.streamId = tempStreamId
        }
        
        if Constants.getLiveStreamStatus() {
            if self.objectOfLiveStream?.is_Live == true {
                self.viewLiveStatus.backgroundColor = UIColor.red
                self.lblLiveStatus.text = "LIVE"
                self.showVideoView()
            } else {
                self.showCoverImageView()
            }
        } else {
            self.showCoverImageView()
        }
        
        self.fetchProductData()
    }
    
    func btnShareLink(index: Int) {
        
        let objectOfLiveStream = self.arrayOfLiveStream[index]
        
        if objectOfLiveStream.streamURL != "" {
            let shareLink = objectOfLiveStream.streamURL
            self.shareLink = objectOfLiveStream.streamURL ?? ""
            let items = [shareLink]
            let ac = UIActivityViewController(activityItems: items as [Any], applicationActivities: nil)
            present(ac, animated: true)
        } else {
            popSnackBar(message: "Share Link not found")
        }
    }
}

extension DashboardViewController: ConnectionProtocol {
    
    func popSnackBar(message: String) {
        
        Utils.popSnackBar(containerView: self.view, message: message)
    }
    
    func Success(TAG: String, json: String, data: Data?) {
        
        let jsonData = JSON.init(parseJSON: json)
        //print("From JSON Data : ", jsonData)
        if let isSuccess = jsonData["success"].bool, isSuccess {
            let data = jsonData["data"]
            if let message = jsonData["message"].string {
                if message == "Ask Question sent successfully" {
                    popSnackBar(message: message)
                    self.hideAskQuestion()
                    self.fetchAskQueCountData()
                }
                if message == "all product listing" {
                    let data = jsonData["data"]
                    self.prepareProductList(jsonData: data)
                }
            }
            self.prepareLiveStreamData(liveStreamData: data)
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
    
    func hideAskQuestion() {
        
        self.viewAskQuestion.isHidden = true
        self.txtViewAskQuestion.text = ""
        self.txtViewAskQuestion.refresh()
    }
    
    func prepareLiveStreamData(liveStreamData: JSON) {
        
        self.indicatorMain.stopAnimating()
        self.indicatorMain.isHidden = true
        
        if let json = liveStreamData.dictionaryValue["live"]?.rawString(), let array = Mapper<LiveStream>().mapArray(JSONString: json) {
            if array.count > 0 {
                self.arrayOfLiveStream = []
            }
            for singleObject in array {
                self.arrayOfLiveStream.append(singleObject)
            }
        }
        
        if let json = liveStreamData.dictionaryValue["completed"]?.rawString(), let array = Mapper<LiveStream>().mapArray(JSONString: json) {
            if array.count > 0 {
                self.arrayOfCompletedLiveStream = []
            }
            for singleObject in array {
                self.arrayOfCompletedLiveStream.append(singleObject)
            }
        }
        
        if self.arrayOfLiveStream.count > 0 {
            
            self.viewCCUpcomingLiveStream.isHidden = false
            self.viewUpcomingNotFound.isHidden = true
            //self.collectionViewLiveStream.reloadData()
            
            if Constants.getLiveStreamStatus() == false {
                for single in self.arrayOfLiveStream {
                    let streamId = single.stream_id
                    if streamId != "" {
                        self.fetchLiveStreamStatus(streamId: streamId!)
                    }
                }
            }
            
            DispatchQueue.main.async {
                //print("From prepareLiveStreamData")
                self.collectionViewLiveStream.reloadData()
                self.scrollToFirstCell()
            }
        } else {
            
            self.viewCCUpcomingLiveStream.isHidden = true
            self.viewUpcomingNotFound.isHidden = false
        }
        
        if self.arrayOfCompletedLiveStream.count > 0 {
            
            self.viewCCPreviousLiveStream.isHidden = false
            self.viewPreviousNotFound.isHidden = true
            self.collectionViewPrevious.reloadData()
        } else {
            
            self.viewCCPreviousLiveStream.isHidden = true
            self.viewPreviousNotFound.isHidden = false
        }
        
        //print("From PrepareList :::::::::::::::::::: ", Constants.getLiveStreamId())
        
        self.resetLiveStreamList()
    }
    
    func resetLiveStreamList() {
        
        if Constants.getLiveStreamStatus() && Constants.getLiveStreamId() != "" {
            
            for singleObject in self.arrayOfLiveStream {
                print("From singleObject : ", singleObject)
                let index = self.arrayOfLiveStream.firstIndex { $0.stream_id == Constants.getLiveStreamId() }
                if index != nil {
                    self.arrayOfLiveStream[index!].is_Live = true
                    self.arrayOfLiveStream.sort { $0.is_Live == true && $1.is_Live == false }
                    self.collectionViewLiveStream.reloadData()
                }
            }
        }
    }
    
    func scrollToFirstCell() {
        
        let when = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.collectionViewLiveStream.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    func scrollToLastCell() {
        
        let count = self.arrayOfLiveStream.count
        let when = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.collectionViewLiveStream.scrollToItem(at: IndexPath(row: count, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    func prepareCompletedLiveStreamData(liveStreamData: JSON) {
        
        //print("From prepareCompletedLiveStreamData ...")
        if let json = liveStreamData.dictionaryValue["live"]?.rawString(), let array = Mapper<LiveStream>().mapArray(JSONString: json) {
            for singleObject in array {
                self.arrayOfCompletedLiveStream.append(singleObject)
            }
        }
        
        //print("From Completed Live Stream Count : ", self.arrayOfCompletedLiveStream.count)
    }
    
    func Failure(TAG: String, error: String) {
        popSnackBar(message: error)
    }
    
    func NoConnection(TAG: String) {
        popSnackBar(message: Constants.noInternet)
    }
}

extension DashboardViewController: AttachProductDelegate {
    
    func shareProductLink(stringProductLink: String) {
        
//        if let url = URL(string: stringProductLink), UIApplication.shared.canOpenURL(url) {
//            UIApplication.shared.open(url)
//        }
        
        //print("From stringProductLink : ", stringProductLink)
        
        if stringProductLink != "" {
            self.delegate.getProductId(productId: stringProductLink)
        } else {
            popSnackBar(message: "Product not found ...")
        }
    }
    
    func deleteProduct(productObject: StreamProduct) {
        
    }
}
