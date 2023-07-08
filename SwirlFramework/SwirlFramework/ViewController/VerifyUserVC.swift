//
//  VerifyUserVC.swift
//  SwirlFramework
//
//  Created by Pinkesh Gajjar on 29/03/23.
//

import UIKit
import Firebase

protocol VerifyUserVCDeleagte {
    
    func submitUserInfo()
    func cancelSubmition()
}

class VerifyUserVC: UIViewController {
    
    @IBOutlet weak var lblDialogTitle: UILabel!
    @IBOutlet weak var tfUserName: DesignableTextField!
    @IBOutlet weak var imgViewFlag: UIImageView!
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var tfUserMobileNo: DesignableTextField!
    @IBOutlet weak var btnSubmit: DesignableButton!
    
    var delegate: VerifyUserVCDeleagte?
    var streamId: String = ""
    let databaseCollectionForMessage = Firestore.firestore().collection("messages")

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpView()
    }
    
    func setUpView() {
        
        self.tfUserName.delegate = self
    }
    
    func createDocument() {
        
        let userId = self.randomString(length: 20)
        let userPhone = self.tfUserMobileNo.text ?? ""
        let userName = self.tfUserName.text ?? ""
        let currntTime = Int(NSDate().timeIntervalSince1970 * 1000)
        let stringTime = String(currntTime)
        
        Constants.setUserMobile(userMobile: userPhone)
        Constants.setUserName(userName: userName)
        
        self.databaseCollectionForMessage.document(self.streamId).collection("users").document(userId).setData([
            "stream_id": self.streamId,
            "country_code": "91",
            "created_date": stringTime,
            "name": userName,
            "phone": userPhone,
            "user_id": userId
        ])
    }
    
    func sendUserDetail() {
        
        self.createDocument()
    }
    
    func randomString(length: Int) -> String {
        
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    @IBAction func btnSubmit(_ sender: UIButton) {
        
        var mobileNumber: String = ""
        var userName: String = ""
        
        if self.tfUserMobileNo.text != nil && self.tfUserMobileNo.text != "" {
            mobileNumber = self.tfUserMobileNo.text ?? ""
        }
        
        if self.tfUserName.text != nil && self.tfUserName.text != "" {
            userName = self.tfUserName.text ?? ""
        }
        
        if mobileNumber == "" {
            popSnackBar(message: "Phone number field cannot be empty.")
            return
        }
        
        if mobileNumber.count != 10 {
            popSnackBar(message: "The phone number you entered must be 10 digits.")
            return
        }
        
        if userName == "" {
            popSnackBar(message: "User name field cannot be empty.")
            return
        }
        
        self.sendUserDetail()
        self.delegate?.submitUserInfo()
        self.dismiss(animated: true)
    }
    
    @IBAction func btnClose(_ sender: UIButton) {
        
        self.delegate?.cancelSubmition()
        self.dismiss(animated: true)
    }
    
    func popSnackBar(message: String) {
        
        Utils.popSnackBar(containerView: self.view, message: message)
    }
}

extension VerifyUserVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.tfUserName {
            let allowedCharacter = CharacterSet.letters
            //let allowedCharacter1 = CharacterSet.whitespaces
            if self.tfUserName.text!.count > 20 {
                popSnackBar(message: "Can not enter more than 20 characters.")
            }
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacter.isSuperset(of: characterSet)
        }
        return true
    }
}
