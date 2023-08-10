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
        tempObject.setUpView()
        tempObject.fetchCommentData(streamId: "NU3ExjLUyecS8PAbwDw9f2nqaBX02iXC3XjCrWtQN2XI")
    }
    
    func setUpView() {
        
        print("From WriteName setUpView ...")
        let bundle = Bundle(identifier: "Swirl.WriteMyName")
        let plistPath = bundle?.path(forResource: "GoogleService-Info", ofType: "plist")
        print("From WriteName setUpView ... 2")
        guard let plistPath = plistPath,
        let options =  FirebaseOptions(contentsOfFile: plistPath)
        else { return }
        if FirebaseApp.app() == nil {
            print("From FirebaseApp nil ")
            FirebaseApp.configure(options: options)
        } else {
            print("From FirebaseApp not nil ")
        }
        print("From WriteName setUpView ... 3")
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
