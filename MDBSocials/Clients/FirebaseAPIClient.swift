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
import Alamofire
import SwiftyJSON
import ObjectMapper
import CoreLocation

class FirebaseAPIClient {
    
    static var postsRef = Database.database().reference()

    public enum RequestTimedOutError: Error {
        case requestTimedOut
    }
    
    static func getPost(id: String) -> Promise<Post>{
        return Promise { fulfill, reject in
            postsRef.child("Posts").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                let json = JSON(snapshot.value)
                if let result = json.dictionaryObject {
                    if let post = Post(JSON: result) {
                        fulfill(post)
                    }
                }
            })
        }
    }
    
    static func fetchPosts(withBlock: @escaping ([Post]) -> ()){
        postsRef.child("Posts").observe(.value, with: { (snapshot) in
            var posts : [Post] = []
            for child in snapshot.children.allObjects {
                let json = JSON((child as! DataSnapshot).value)
                if let result = json.dictionaryObject {
                    if let post = Post(JSON: result){
                        posts.append(post)
                    }
                }
            }
            withBlock(posts)
        })
    }
    
    static func fetchUser(id: String) -> Promise<SocialsUser> {
        return Promise { fulfill, reject in
            let ref = Database.database().reference()
            ref.child("Users").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                let user = SocialsUser(id: snapshot.key, userDict: snapshot.value as! [String : Any])
                fulfill(user)
            })
        }
    }
    
    static func createNewPost(postText: String, postDescription: String, date: String, location: CLLocationCoordinate2D, poster: String, imageData: Data, posterId: String) {
        print("beginning of createNewPost")
        
        let postsRef = Database.database().reference().child("Posts")
        let key = postsRef.childByAutoId().key
        let storage = Storage.storage().reference().child("Images/\(key).jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        storage.putData(imageData, metadata: metadata).observe(.success) { (snapshot) in
            print("inside of puttingData")
            let imageUrl = snapshot.metadata?.downloadURL()?.absoluteString as! String
            let newPost = ["id": "/\(key)/","text": postText, "description": postDescription, "date": date, "latitude": location.latitude, "longitude": location.longitude, "poster" : poster, "imageUrl": imageUrl, "posterId": posterId, "numInterested": 0, "membersInterested" : ["Hi"]] as [String : Any]
            let childUpdates = ["/\(key)/": newPost]
            postsRef.updateChildValues(childUpdates)
            print("should've just created a new post")
        }
    }
    
    
    static func createNewUser(id: String, name: String, username: String, email: String, imageData: Data) {
        print("Creating new user in database...")
        let usersRef = Database.database().reference().child("Users")
        let key = usersRef.childByAutoId().key
        let storage = Storage.storage().reference().child("Images/\(key).jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        storage.putData(imageData, metadata: metadata).observe(.success) { (snapshot) in
            let imageUrl = snapshot.metadata?.downloadURL()?.absoluteString as! String
            let newUser = ["name": name, "email": email, "username": username, "imageUrl": imageUrl, "postsInterested": ["Hi"]] as [String : Any]
            let childUpdates = ["/\(id)/": newUser]
            usersRef.updateChildValues(childUpdates)
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
        
    }
}





