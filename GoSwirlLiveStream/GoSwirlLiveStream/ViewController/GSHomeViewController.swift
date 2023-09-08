//
//  GSHomeViewController.swift
//  GoSwirlLiveStream
//
//  Created by Pinkesh Gajjar on 04/09/23.
//

import UIKit
import AVKit
import FirebaseCore
import FirebaseFirestore
import IQKeyboardManagerSwift

public class GSHomeViewController: UIViewController , UITextFieldDelegate {
    
    @IBOutlet weak var viewMainVideo: UIView!
    @IBOutlet weak var viewLiveStreamListing: UIView!
    @IBOutlet weak var viewUpcomingLabel: UIView!
    @IBOutlet weak var lblUpcomingTitle: UILabel!
    
    @IBOutlet weak var viewCCUpcomingLiveStream: UIView!
    @IBOutlet weak var collectionViewLiveStream: UICollectionView!
    @IBOutlet weak var viewUpcomingNotFound: UIView!
    @IBOutlet weak var lblUpcomingNotFound: UILabel!
    
    @IBOutlet weak var viewPreviousLabel: UIView!
    @IBOutlet weak var lblPreviousTitle: UILabel!
    @IBOutlet weak var viewCCPreviousLiveStream: UIView!
    @IBOutlet weak var collectionViewPrevious: UICollectionView!
    @IBOutlet weak var viewPreviousNotFound: UIView!
    @IBOutlet weak var lblPreviousNotFound: UILabel!
    
    @IBOutlet weak var viewStreamVideo: UIView!
    @IBOutlet weak var viewBottomAlpha: UIView!
    @IBOutlet weak var viewBottomButton: DesignableView!
    @IBOutlet weak var btnProductList: MIBadgeButton!
    @IBOutlet weak var btnAskQuestion: MIBadgeButton!
    @IBOutlet weak var btnShowChat: DesignableButton!
    @IBOutlet weak var imgViewLike: UIImageView!
    @IBOutlet weak var btnLike: MIBadgeButton!
    @IBOutlet weak var btnCloseLiveStream: DesignableButton!
    @IBOutlet weak var btnShareLink: DesignableButton!
    @IBOutlet weak var viewMuteButton: UIView!
    @IBOutlet weak var imgViewMute: UIImageView!
    @IBOutlet weak var btnMute: DesignableButton!
    @IBOutlet weak var viewLiveStatus: DesignableView!
    @IBOutlet weak var lblLiveStatus: UILabel!
    @IBOutlet weak var viewPinLastComment: UIView!
    @IBOutlet weak var viewLastComment: UIView!
    @IBOutlet weak var viewAlphaLastComment: UIView!
    @IBOutlet weak var lblLastComment: UILabel!
    @IBOutlet weak var btnShowChatLastComment: DesignableButton!
    @IBOutlet weak var viewPinComment: UIView!
    @IBOutlet weak var viewAlphaPinComment: UIView!
    @IBOutlet weak var lblPinComment: UILabel!
    @IBOutlet weak var viewProductList: UIView!
    @IBOutlet weak var viewAskQuestionList: UIView!
    @IBOutlet weak var lblProductTitle: UILabel!
    @IBOutlet weak var tableViewProductList: UITableView!
    @IBOutlet weak var viewLiveChat: UIView!
    @IBOutlet weak var btnCloseLiveChatView: DesignableButton!
    @IBOutlet weak var lblLiveChatTitle: UILabel!
    @IBOutlet weak var viewLiveChatChild: UIView!
    @IBOutlet weak var tableViewLiveChat: UITableView!
    @IBOutlet weak var viewLiveChatSeparator: UIView!
    @IBOutlet weak var viewMainSendMsgTF: UIView!
    @IBOutlet weak var viewSendMsgTF: DesignableView!
    @IBOutlet weak var btnSendMessage: DesignableButton!
    @IBOutlet weak var tfSendMessage: DesignableTextField!
    
    @IBOutlet weak var csStackButtonBottom: NSLayoutConstraint!
    @IBOutlet weak var csCVLiveStream: NSLayoutConstraint!//215
    @IBOutlet weak var csCloseBtnTop: NSLayoutConstraint!//25
    @IBOutlet weak var csCVPreviousHeight: NSLayoutConstraint!//215
    
    var comments = [Comment].init()
    var arrayOfTempComment = [Comment].init()
    var arrayOfLiveStream = [LiveStreams].init()
    var arrayOfCompletedLiveStream = [LiveStreams].init()
    
    var arrayOfProducts = [Products].init()
    var objectOfLiveStream: LiveStreamsData? = nil
    
    var tempUrl: String = ""
    var messageCount: Int = 0
    var streamId: String = "NU3ExjLUyecS8PAbwDw9f2nqaBX02iXC3XjCrWtQN2XI"
    
    let playerController = AVPlayerViewController()
    var player: AVPlayer?

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpView()
    }
    
    func setUpView() {
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        if #available(iOS 13.0, *) {
            NotificationCenter.default.addObserver(self, selector: #selector(willEnterForegroundNotification), name: UIScene.willEnterForegroundNotification, object: nil)
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(willEnterForegroundNotification), name: UIApplication.willEnterForegroundNotification, object: nil)
        }
        
        self.setCollectionView()
        self.setUpTableView()
        self.updateConstraint()
        self.setUpFirebase()
        
        self.fetchLiveStreamData()
        
        self.viewProductList.isHidden = true
        self.viewLiveChat.isHidden = true
        self.viewAskQuestionList.isHidden = true
        
        self.fetchCommentData(streamId: "")
    }
    
    func fetchLiveStreamData() {
        
        let params = ["designer_id" : "19791"]
        guard let serviceUrl = URL(string: "https://api.goswirl.live/index.php/api/Designer/streamlisting") else { return }
        ApiService.callPost(url: serviceUrl, params: params, finish: getLiveStreamData)
    }
    
    func getLiveStreamData (message:String, data:Data?) -> Void {
        
        guard let data = data else {
            print(String(describing: message))
            return
        }
        
        //print(String(data: data, encoding: .utf8)!)
        
        let jsonString = String(data: data, encoding: .utf8)!
        //print("From Json String : ", jsonString)
        
        do {
            
            let dic = try JSONSerialization.jsonObject(with: Data(jsonString.utf8)) as! NSDictionary
            //print("From dic : ", dic["data"] as! Array<Any>)
            let jsonArray = dic["data"] as! Array<Any>
                
            self.objectOfLiveStream = LiveStreamsData(jsonData: jsonArray as NSArray)
            //print("From objectOfLiveStream : ", self.objectOfLiveStream as Any)
            
            let temp = self.objectOfLiveStream?.arrayOfLiveStreams ?? []
            self.arrayOfLiveStream = temp
            if self.arrayOfLiveStream.count > 0 {
                DispatchQueue.main.async {
                    self.collectionViewLiveStream.reloadData()
                }
            }
        }
        catch {
            print(error)
        }
    }
    
    func updateConstraint() {
        
        if UIDevice.current.hasNotch {
            self.csCloseBtnTop.constant = 40
            self.csStackButtonBottom.constant = 24
        } else {
            self.csCloseBtnTop.constant = 25
            self.csStackButtonBottom.constant = 8
        }
    }
    
    @objc func willEnterForegroundNotification(_ notification: Notification) {
        
        //self.player?.play()
    }
    
    func setUpFirebase() {
        
        let secondaryOptions = FirebaseOptions(googleAppID: "1:379458465537:ios:b49cd992c7fdc25d4f7500",
                                               gcmSenderID: "379458465537")
        secondaryOptions.apiKey = "AIzaSyDkY6LYbcxYLsPHAG1MV6d3fzN8NuMSlIk"
        secondaryOptions.projectID = "getnatty-1547727043139"

        // The other options are not mandatory, but may be required
        // for specific Firebase products.
        //secondaryOptions.bundleID = "com.golive.swirl"
        secondaryOptions.clientID = "379458465537-vnfja4fcg80h6o4peff3rnq6c1v4clb9.apps.googleusercontent.com"
        secondaryOptions.databaseURL = "https://getnatty-1547727043139.firebaseio.com"
        secondaryOptions.storageBucket = "getnatty-1547727043139.appspot.com"
        FirebaseApp.configure(name: "goswirl", options: secondaryOptions)
    }
    
    func fetchCommentData(streamId: String) {
        
        guard let secondary = FirebaseApp.app(name: "goswirl")
         else { assert(false, "Could not retrieve secondary app") }
        
        let databaseCollectionForMessage = Firestore.firestore(app: secondary).collection("messages")
        databaseCollectionForMessage.document("NU3ExjLUyecS8PAbwDw9f2nqaBX02iXC3XjCrWtQN2XI").collection("messages").order(by: "created_time")
        .addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            if snapshot.count > 0 {
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
                                //self.showCurrentAndPinComment()
                                self.tableViewLiveChat.reloadData()
                            }
                        }
                    }
                }
            } else {
                //self.isCommentFound = false
                //self.deleteAllComment()
            }
            
            //self.arrayOfTempComment = Array(self.comments.reversed())
            self.arrayOfTempComment = Array(self.comments)
            if self.arrayOfTempComment.count > 0 {
                //print("From Last Message : ", self.arrayOfTempComment.first as Any)
                //self.showCurrentAndPinComment()
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
    
    func tableViewScrollBottom() {
        
        UIView.animate(withDuration: 0.2, delay: 0.1, options: .transitionFlipFromBottom, animations: {
            self.tableViewLiveChat.reloadData()
            if self.arrayOfTempComment.count > 0 {
                self.tableViewLiveChat.scrollToBottom(isAnimated: false)
            }
        }, completion: nil)
    }
    
    func setCollectionView() {
        
        self.collectionViewLiveStream.delegate = self
        self.collectionViewLiveStream.dataSource = self
        self.csCVLiveStream.constant = CGFloat(Constants.deviceWidth / 1.72) + 1
        
        self.collectionViewPrevious.delegate = self
        self.collectionViewPrevious.dataSource = self
        self.csCVPreviousHeight.constant = CGFloat(Constants.deviceWidth / 1.72) + 1
    }
    
    func setUpTableView() {
        
        self.tableViewLiveChat.delegate = self
        self.tableViewLiveChat.dataSource = self
        self.tableViewLiveChat.tableFooterView = UIView.init()
        self.tableViewLiveChat.isHidden = true
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
    
    func playVideo(videoUrl: String) {
        
        let videoUrl = "https://stream.mux.com/wborxF8TMUGI1YinQKjar202rl0000YEpUzeJAlaV1SORI/high.mp4"
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
    
    @IBAction func btnProductList(_ sender: UIButton) {
        
    }
    
    @IBAction func btnAskQuestion(_ sender: UIButton) {
        
    }
    
    @IBAction func btnShowChatView(_ sender: UIButton) {
        
        self.viewLiveChat.isHidden = false
    }
    
    @IBAction func btnCloseChatView(_ sender: UIButton) {
        
        self.viewLiveChat.isHidden = true
    }
    
    @IBAction func btnLike(_ sender: UIButton) {
        
    }
    
    @IBAction func btnSendMsg(_ sender: UIButton) {
        
        guard let message = self.tfSendMessage.text, !message.isEmpty else {
            popSnackBar(message: "This field is mandatory")
            return
        }
        
        self.messageCount = self.messageCount + 1
        
        guard let secondary = FirebaseApp.app(name: "goswirl")
         else { assert(false, "Could not retrieve secondary app") }
        
        let databaseCollectionForMessage = Firestore.firestore(app: secondary).collection("messages")
        databaseCollectionForMessage.document(self.streamId).setData([
            "stream_id": self.streamId
        ])
        
        let currntTime = Int(NSDate().timeIntervalSince1970 * 1000)
        databaseCollectionForMessage.document(self.streamId).collection("messages").addDocument(data: [
            "from": Constants.getUserName(),
            "message": message,
            "type": "text",
            "created_time":currntTime,
            "is_designer": true,
            "is_user": false,
            "name": "SDK",
            "profile": "no profile",
            "user_phone": "no user_phone",
            "is_designer_seen": true,
            "is_user_seen": true,
            "cover_img": "",
            "title": Constants.liveNowTitle,
            "index": self.messageCount
        ])
        self.tfSendMessage.text = nil
    }
    
    func popSnackBar(message: String) {
        
        Utils.popSnackBar(containerView: self.view, message: message)
    }
    
    @objc override func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func btnCloseLiveStream(_ sender: UIButton) {
        
        self.dismiss(animated: true)
    }
}

extension GSHomeViewController : UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrayOfTempComment.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
    }
}

extension GSHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
//        print("From numberOfItemsInSection : ", self.arrayOfLiveStream.count)
//        if collectionView == self.collectionViewLiveStream {
//            return self.arrayOfLiveStream.count
//        } else if collectionView == self.collectionViewPrevious {
//            return self.arrayOfCompletedLiveStream.count
//        } else {
//            return 5
//        }
        return 5
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        print("From cellForItemAt ")
        if collectionView == self.collectionViewLiveStream {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LiveStreamCollectionViewCell", for: indexPath) as! LiveStreamCollectionViewCell
            cell.tag = indexPath.row
            cell.delegate = self
            cell.btnSelectCell.tag = indexPath.row
            cell.btnShareLink.tag = indexPath.row
            //cell.objectOfLiveStream = self.arrayOfLiveStream[indexPath.row]
            //cell.configCell()
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PreviousStreamCollectionViewCell", for: indexPath) as! PreviousStreamCollectionViewCell
            cell.delegate = self
            cell.btnSelectCell.tag = indexPath.row
            cell.btnShareLink.tag = indexPath.row
            //cell.objectOfLiveStream = self.arrayOfCompletedLiveStream[indexPath.row]
            //cell.configCell()
            return cell
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = CGFloat(Constants.deviceWidth / 2.8)
        let cellHieght = CGFloat(Constants.deviceWidth / 1.72)
        return CGSize.init(width: cellWidth, height: cellHieght)
    }
}

extension GSHomeViewController: PreviousCCDelegate {
    
    func btnSelectPreviousCell(index: Int) {
        
        self.viewLiveStreamListing.isHidden = true
        self.playVideo(videoUrl: "")
    }
    
    func btnSelectShareLink(index: Int) {
        
        self.viewLiveStreamListing.isHidden = true
        self.playVideo(videoUrl: "")
    }
}

extension GSHomeViewController: LiveStreamCCDelegate {
    
    func btnSelectCell(index: Int) {
        
    }
    
    func btnShareLink(index: Int) {
        
    }
}
