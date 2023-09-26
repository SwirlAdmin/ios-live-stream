//
//  PreviousStreamCollectionViewCell.swift
//  SwirlFramework
//
//  Created by Pinkesh Gajjar on 18/08/22.
//

import UIKit

protocol PreviousCCDelegate {
    
    func btnSelectPreviousCell(index: Int)
    func btnSelectShareLink(index: Int)
}

class PreviousStreamCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var btnSelectCell: UIButton!
    @IBOutlet weak var imgViewThumbnail: DesignableImageView!
    @IBOutlet weak var csImgViewWidth: NSLayoutConstraint!//140
    @IBOutlet weak var csImgViewHeight: NSLayoutConstraint!//171
    @IBOutlet weak var viewStreamTimeDate: DesignableView!
    @IBOutlet weak var lblStreamTimeDate: UILabel!
    @IBOutlet weak var btnShareLink: UIButton!
    @IBOutlet weak var lblLiveStreamName: UILabel!
    @IBOutlet weak var lblStreamDuration: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var viewContent: DesignableView!
    
    var objectOfLiveStream: LiveStreams? = nil
    var delegate: PreviousCCDelegate! = nil
    
    func configCell() {
        
        //print("From configCell : ", self.objectOfLiveStream as Any)
        self.updateCellConstraints()
        
        let startDate = self.objectOfLiveStream?.starting_time ?? ""
        var startDateFormat: String = ""
        if startDate != "" {
            startDateFormat = Utils.getFormatDate(date: startDate, fromFormat: "yyyy-MM-dd HH:mm:ss", toFormat: "dd MMM")
        }
        
        self.lblStreamTimeDate.text = startDateFormat
        
        self.imgViewThumbnail.loadImage(imageUrl: self.objectOfLiveStream?.cover_img, placeHolder: "ph_swirl", isCache: true, contentMode: .scaleAspectFill)
        
        if let streamTitle = self.objectOfLiveStream?.title {
            self.lblLiveStreamName.text = streamTitle.titleCase()
        } else {
            self.lblLiveStreamName.text = "---"
        }
        
        if let durationTime = self.objectOfLiveStream?.duration_time {
            self.lblStreamDuration.text = durationTime
        } else {
            self.lblStreamDuration.text = "---"
        }
    }
    
    func updateCellConstraints() {
        
        let cellWidth = CGFloat(GSConstants.deviceWidth / 2.8)
        let cellHeight = CGFloat(GSConstants.deviceWidth / 1.72) - 40
        self.csImgViewHeight.constant = cellHeight
        self.csImgViewWidth.constant = cellWidth
    }
    
    @IBAction func btnSelectCell(_ sender: UIButton) {
        
        self.delegate.btnSelectPreviousCell(index: sender.tag)
    }
    
    @IBAction func btnShareLink(_ sender: UIButton) {
        
        //print("From btnShareLink")
        self.delegate.btnSelectShareLink(index: sender.tag)
    }
    
    @IBAction func btnPlay(_ sender: UIButton) {
        
        
    }
    
}
