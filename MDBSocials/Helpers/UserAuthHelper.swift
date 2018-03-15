//
//  UserAuthHelper.swift
//  FirebaseDemoMaster
//
//  Created by Sahil Lamba on 2/16/18.
//  Copyright © 2018 Vidya Ravikumar. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase
import Firebase

class UserAuthHelper {
    
    static func logIn(email: String, password: String, view: UIViewController, withBlock: @escaping (User?)->()) {
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user: User?, error) in
            if error == nil {
                withBlock(user)
                beaverLog.info("User with email: \(email) signed in")
            } else {
                view.view.isUserInteractionEnabled = true
                let alert = UIAlertController(title: "Error", message: "This username and password did not match a current user.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                view.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    static func logOut(withBlock: @escaping ()->()) {
        //TODO: Log out using Firebase!
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            beaverLog.info("User logged out.")
            withBlock()
        } catch let signOutError as NSError {
            beaverLog.error(signOutError)
        }
    }
    
    static func createUser(name: String, username: String, email: String, password: String, imageData: Data?, view: UIViewController, withBlock: @escaping (String) -> ()) {
        if imageData != nil {
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user: User?, error) in
                if error == nil {
                    RestAPIClient.createNewUser(id: (user?.uid)!, name: name, username: username, email: email, imageData: imageData!)
                    withBlock((user?.uid)!)
                }
                else {
                    view.view.isUserInteractionEnabled = true
                    beaverLog.error(error.debugDescription)
                }
            })
        }
    }
        
    
}

