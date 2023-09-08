//
//  CommentCell.swift
//  LiveStreamDemo
//
//  Created by A.Live Mind on 07/09/20.
//  Copyright © 2020 ALiveMind. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var ivProfile: DesignableImageView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var viewLblMessage: UIView!
    
    var tempUrl: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //ivProfile.image = nil
    }
    
    func configCell(userId: String) {
        
        self.setLabelView()
        self.viewLblMessage.alpha = 1
        if userId == GSConstants.getUserBrandId() {
            self.viewLblMessage.backgroundColor = UIColor.init(hex: "#000000")
            self.lblMessage.textColor = UIColor.white
        } else {
            self.viewLblMessage.backgroundColor = UIColor.init(hex: "#E7E7E7")
            self.lblMessage.textColor = UIColor.black
        }
        
        if self.lblMessage.text != nil && self.lblMessage.text != "" {
            self.tempUrl = self.lblMessage.text ?? ""
        }
    }
    
    func configCellForURL(userId: String) {
        
        self.setLabelView()
        self.viewLblMessage.alpha = 1
        if userId == GSConstants.getUserBrandId() {
            self.viewLblMessage.backgroundColor = UIColor.init(hex: "#000000")
        } else {
            self.viewLblMessage.backgroundColor = UIColor.init(hex: "#E7E7E7")
        }
        
        if self.lblMessage.text != nil && self.lblMessage.text != "" {
            self.tempUrl = self.lblMessage.text ?? ""
        }
    }
    
    func setLabelClickable(tempMsg: String) {
        
        self.tempUrl = tempMsg
        //let urlString = "example.com"
        let urlHasHttpPrefix = tempUrl.hasPrefix("http://")
        let urlHasHttpsPrefix = tempUrl.hasPrefix("https://")
        let validUrlString = (urlHasHttpPrefix || urlHasHttpsPrefix) ? tempUrl : "https://\(tempUrl)"
        //print("From validUrlString : ", validUrlString)
        self.tempUrl = validUrlString
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapFunction))
        self.lblMessage.isUserInteractionEnabled = true
        self.lblMessage.addGestureRecognizer(tap)
        self.lblMessage.text = self.tempUrl
        self.lblMessage.textColor = UIColor.blue
    }
    
    @IBAction func tapFunction(sender: UITapGestureRecognizer) {
        
        if let url = URL(string: self.lblMessage.text ?? "") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
    
    func validateURL(url: String) -> Bool {
        
        let regex = "http[s]?://(([^/:.[:space:]]+(.[^/:.[:space:]]+)*)|([0-9](.[0-9]{3})))(:[0-9]+)?((/[^?#[:space:]]+)([^#[:space:]]+)?(#.+)?)?"
        let test = NSPredicate(format:"SELF MATCHES %@", regex)
        let result = test.evaluate(with: url)
        return result
    }
    
    func setLabelView() {
        
        self.viewLblMessage.layer.cornerRadius = 5
    }

}



