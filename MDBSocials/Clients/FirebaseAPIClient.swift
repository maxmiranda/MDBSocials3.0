//
//  FirebaseDemoAPIClient.swift
//  FirebaseDemoMaster
//
//  Created by Sahil Lamba on 2/16/18.
//  Copyright © 2018 Vidya Ravikumar. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import PromiseKit
import SwiftyJSON
import ObjectMapper
import CoreLocation

class FirebaseAPIClient {
    
    static var postsRef = Database.database().reference()

    public enum RequestTimedOutError: Error {
        case requestTimedOut
    }
    
    static func createNewPost(postText: String, postDescription: String, date: String, location: CLLocationCoordinate2D, poster: String, imageData: Data, posterId: String) {
        
        let postsRef = Database.database().reference().child("Posts")
        let key = postsRef.childByAutoId().key
        let storage = Storage.storage().reference().child("Images/\(key).jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        storage.putData(imageData, metadata: metadata).observe(.success) { (snapshot) in
            let imageUrl = snapshot.metadata?.downloadURL()?.absoluteString as! String
            let newPost = ["id": "/\(key)/","text": postText, "description": postDescription, "date": date, "latitude": location.latitude, "longitude": location.longitude, "poster" : poster, "imageUrl": imageUrl, "posterId": posterId, "numInterested": 0, "membersInterested" : ["Hi"]] as [String : Any]
            let childUpdates = ["/\(key)/": newPost]
            postsRef.updateChildValues(childUpdates)
            beaverLog.info("Post created.")
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newPost"), object: nil, userInfo: nil)
        }
    }
    
    static func incrementPostInterested(postId: String, cUserId: String) {
        let postRef = Database.database().reference().child("Posts/\(postId)")
        let usersRef = Database.database().reference().child("Users/\(cUserId)")
        
        usersRef.child("postsInterested").observeSingleEvent(of: .value, with: { (snapshot) in
            if var value = snapshot.value as? [String]{
                value.append(postId)
                let update = ["postsInterested" : value] as [String : Any]
                usersRef.updateChildValues(update)
            }
        })
            
        postRef.child("membersInterested").observeSingleEvent(of:.value, with: { (snapshot) in
            if var value = snapshot.value as? [String]{
                value.append(cUserId)
                let update = ["membersInterested" : value] as [String : Any]
                postRef.updateChildValues(update)
            }
        })
        
        postRef.child("numInterested").observeSingleEvent(of:.value, with: { (snapshot) in
            if let value = snapshot.value as? Int{
                let update = ["numInterested" : value + 1] as [String : Any]
                postRef.updateChildValues(update)
            }
        })
        beaverLog.info("incremented NumInterested")
    }
}





