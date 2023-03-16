//
//  LiveStreamCollectionViewCell.swift
//  SwirlFramework
//
//  Created by Pinkesh Gajjar on 17/08/22.
//

import UIKit

protocol LiveStreamCCDelegate {
    
    func btnSelectCell(index: Int)
    func btnShareLink(index: Int)
}

class LiveStreamCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var btnSelectCell: UIButton!
    @IBOutlet weak var imgViewThumbnail: DesignableImageView!
    @IBOutlet weak var csImgViewWidth: NSLayoutConstraint!//140
    @IBOutlet weak var csImgViewHeight: NSLayoutConstraint!//171
    
    @IBOutlet weak var btnShareLink: UIButton!
    @IBOutlet weak var lblLiveStreamName: UILabel!
    @IBOutlet weak var viewLiveLabel: DesignableView!
    @IBOutlet weak var lblLiveStatus: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
    
    var delegate: LiveStreamCCDelegate! = nil
    var objectOfLiveStream: LiveStream? = nil
    
    func configCell() {
        
        self.updateCellConstraints()
        
        let startDate = self.objectOfLiveStream?.starting_time ?? ""
        var startDateFormat: String = ""
        if startDate != "" {
            startDateFormat = Utils.getFormatDate(date: startDate, fromFormat: "yyyy-MM-dd HH:mm:ss", toFormat: "dd MMM")
        }
        
        self.imgViewThumbnail.loadImage(imageUrl: self.objectOfLiveStream?.cover_img, placeHolder: "ph_swirl", isCache: true, contentMode: .scaleAspectFill)
        
        if self.objectOfLiveStream?.is_Live == true {
            self.viewLiveLabel.backgroundColor = UIColor(hex: "#EE3445")
            self.lblLiveStatus.text = "Live"
        } else {
            self.viewLiveLabel.backgroundColor = UIColor(hex: "#000000")
            self.lblLiveStatus.text = startDateFormat
        }
        
        if let streamTitle = self.objectOfLiveStream?.title {
            self.lblLiveStreamName.text = streamTitle.trim()
        } else {
            self.lblLiveStreamName.text = "---"
        }
    }
    
    func updateCellConstraints() {
        
        let cellWidth = CGFloat(Constants.deviceWidth / 2.8)
        let cellHeight = CGFloat(Constants.deviceWidth / 1.72) - 40
        self.csImgViewHeight.constant = cellHeight
        self.csImgViewWidth.constant = cellWidth
    }
    
    @IBAction func btnSelectCell(_ sender: UIButton) {
        
        self.delegate.btnSelectCell(index: sender.tag)
    }
    
    @IBAction func btnShareLink(_ sender: UIButton) {
        
        self.delegate.btnShareLink(index: sender.tag)
    }
    
    @IBAction func btnPlay(_ sender: UIButton) {
        
        
    }
}
