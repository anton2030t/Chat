//
//  CreateUser.swift
//  FirebaseChatApp
//
//  Created by Антон Ларченко on 24.02.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import SwiftUI
import Firebase

func createUser(name: String, about: String, imagedata: Data, completion: @escaping (Bool)-> Void) {
    
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()
    let uid = Auth.auth().currentUser?.uid
    
    storage.child("profilepics").child(uid!).putData(imagedata, metadata: nil) { (_, err) in
        
        if err != nil {
            print((err?.localizedDescription)!)
            return
        }
        storage.child("profilepics").child(uid!).downloadURL { (url, err) in
            
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            db.collection("users").document(uid!).setData(["name":name,"about":about,"pic":"\(url!)","uid":uid!]) { (err) in
                
                if err != nil {
                    print((err?.localizedDescription)!)
                    return
                }
                completion(true)
                UserDefaults.standard.set(true, forKey: "status")
                UserDefaults.standard.set(name, forKey: "UserName")
                UserDefaults.standard.set(uid, forKey: "UID")
                UserDefaults.standard.set("\(url!)", forKey: "pic")
                NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
            }
        }
    }
}
