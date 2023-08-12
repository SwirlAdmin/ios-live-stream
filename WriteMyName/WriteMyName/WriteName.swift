//
//  WriteName.swift
//  WriteMyName
//
//  Created by Pinkesh Gajjar on 04/07/23.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

public struct WriteName {
    
    public static func sayHello() {
        print("From PMGajjar sayHello")
    }
    
    public static func sayHi() {
        print("From Pinkesh Gajjar sayHi")
    }
    
    public static func getData() {
        
        let tempObject = WriteName()
        let testCode1 = tempObject.setUpView()
//        if testCode1 == false {
//            let testCode2 = tempObject.setUpView2()
//        }
        print("From getData value : ", testCode1)
        tempObject.fetchCommentData(streamId: "NU3ExjLUyecS8PAbwDw9f2nqaBX02iXC3XjCrWtQN2XI")
    }
    
    func setUpView() -> Bool {
        
        print("From WriteName setUpView ...")
        let bundle = Bundle(identifier: "Swirl.WriteMyName")
        let plistPath = bundle?.path(forResource: "GoogleService-Info", ofType: "plist")
        print("From WriteName setUpView plistPath : ", plistPath as Any)
        guard let plistPath = plistPath,
        let options =  FirebaseOptions(contentsOfFile: plistPath)
        else {
            print("From WriteName setUpView ... 3")
            return false
        }
        if FirebaseApp.app() == nil {
            print("From FirebaseApp nil ")
            FirebaseApp.configure(options: options)
        } else {
            print("From FirebaseApp not nil ")
        }
        print("From WriteName setUpView ... 4")
        return true
    }
    
    func setUpView2() -> Bool {
        
        print("From WriteName setUpView2 ...")
        let bundle = Bundle(identifier: "Swirl.WriteMyName")
        let plistPath = bundle?.path(forResource: "GoogleService-Info", ofType: "plist")
        print("From WriteName setUpView2 plistPath : ", plistPath as Any)
        guard let plistPath = plistPath,
        let options =  FirebaseOptions(contentsOfFile: plistPath)
        else {
            print("From WriteName setUpView2 ... 3")
            return false
        }
        if FirebaseApp.app() == nil {
            print("From FirebaseApp setUpView2 nil ")
            FirebaseApp.configure(options: options)
        } else {
            print("From FirebaseApp setUpView2 not nil ")
        }
        print("From WriteName setUpView2 ... 4")
        return true
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
}
