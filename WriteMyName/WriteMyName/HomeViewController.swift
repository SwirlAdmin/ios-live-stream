//
//  HomeViewController.swift
//  WriteMyName
//
//  Created by Pinkesh Gajjar on 19/08/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

public class HomeViewController: UIViewController {
    
    let objFirebaseApp = FirebaseApp.app()

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    public static func getData() {
        
//        let tempObject = WriteName()
//        tempObject.setUpFireStore()
//
////        let testCode1 = tempObject.setUpView()
////        if testCode1 == false {
////            tempObject.setUpView3()
////        }
////        print("From getData value : ", testCode1)
//
//        tempObject.fetchCommentData(streamId: "NU3ExjLUyecS8PAbwDw9f2nqaBX02iXC3XjCrWtQN2XI")
    }
    
    func setUpFireStore() {
        
        print("From setUpFireStore ...")
        let secondaryOptions = FirebaseOptions(googleAppID: "1:379458465537:ios:b49cd992c7fdc25d4f7500",
                                               gcmSenderID: "379458465537")
        secondaryOptions.apiKey = "AIzaSyDkY6LYbcxYLsPHAG1MV6d3fzN8NuMSlIk"
        secondaryOptions.projectID = "getnatty-1547727043139"

        //secondaryOptions.bundleID = "com.golive.swirl"
        secondaryOptions.clientID = "379458465537-vnfja4fcg80h6o4peff3rnq6c1v4clb9.apps.googleusercontent.com"
        secondaryOptions.databaseURL = "https://getnatty-1547727043139.firebaseio.com"
        secondaryOptions.storageBucket = "getnatty-1547727043139.appspot.com"
                
        //FirebaseApp.configure(name: "secondary", options: secondaryOptions)
        if self.objFirebaseApp == nil {
            print("From setUpFireStore objFirebaseApp nil ...")
            FirebaseApp.configure(options: secondaryOptions)
        } else {
            self.objFirebaseApp?.delete({ (success) in
                FirebaseApp.configure(options: secondaryOptions)
            })
            print("From setUpFireStore objFirebaseApp not nil ...")
        }
        
        self.fetchCommentData(streamId: "NU3ExjLUyecS8PAbwDw9f2nqaBX02iXC3XjCrWtQN2XI")
    }
    
    func fetchCommentData(streamId: String) {
        
        let databaseCollectionForMessage = Firestore.firestore().collection("messages")
        databaseCollectionForMessage.document(streamId).collection("messages").order(by: "created_time")
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
                                //self.addCommentData(data: diff.document.data())
                                print("From Added Comment Data : ",diff.document.data())
                            }
                            if (diff.type == .modified) {
                                //self.comments.append(diff.document.data())
                                print("From Modified Comment Data : ",diff.document.data())
                            }
                            if (diff.type == .removed) {
                                print("From comment document removed : \(diff.document.data())")
                                //self.deleteCommentData(data: diff.document.data())
                                //self.showCurrentAndPinComment()
                                //self.tableViewLiveChat.reloadData()
                            }
                        }
                    }
                }
            } else {
                //self.isCommentFound = false
                //self.deleteAllComment()
            }
            
            //self.arrayOfTempComment = Array(self.comments.reversed())
        }
    }
    
    @IBAction func btnClick(_ sender: UIButton) {
        
        self.setUpFireStore()
    }
}
