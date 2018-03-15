//
//  RESTAPIClient.swift
//  MDBSocials
//
//  Created by Max Miranda on 3/14/18.
//  Copyright © 2018 ___MaxAMiranda___. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit
import SwiftyJSON
import FirebaseStorage
import CoreLocation

class RestAPIClient {
    
    static func createNewUser(id: String, name: String, username: String, email: String, imageData: Data) {
        
        let storage = Storage.storage().reference().child("Images/\(id)")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        beaverLog.info("Starting profile image storage")
        storage.putData(imageData, metadata: metadata).observe(.success) { (snapshot) in
            beaverLog.info("Profile image stored.")
            let url = snapshot.metadata?.downloadURL()?.absoluteString as! String
            
            let endpoint = "https://max-mdb-socials.herokuapp.com/users/\(id)"
            let requestParameters: [String : Any] = [
                "name": name,
                "username": username,
                "email": email,
                "imageUrl": url
            ]
            Alamofire.request(endpoint, method: .post, parameters: requestParameters, encoding: URLEncoding.default, headers: nil).responseJSON().done { response -> Void in
                    beaverLog.info("Successfully put new user \(name) with id: \(id)")
                }.catch { error in
                    beaverLog.error(error.localizedDescription)
            }
        }
    }
    
    static func createNewPost(text: String, description: String, date: String, location: CLLocationCoordinate2D, poster: String, imageData: Data, posterId: String) {
        
        let endpoint = "https://max-mdb-socials.herokuapp.com/posts"
        let requestParameters: [String : Any] = [
            "text": text,
            "description": description,
            "date": date,
            "latitude": location.latitude,
            "longitude": location.longitude,
            "poster" : poster,
            "poserId" : posterId
        ]
        var pid : Any?
        Alamofire.request(endpoint, method: .post, parameters: requestParameters, encoding: URLEncoding.default, headers: nil).responseJSON().done { response -> Void in
            var json = JSON(response.json)
            if var result = json.dictionaryObject {
                pid = result["id"]
            }
            beaverLog.info("Successfully put new post \(text) with id \(pid!)")
            }.catch { error in
                beaverLog.error(error.localizedDescription)
        }
        
        let storage = Storage.storage().reference().child("Images/\(pid).jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        storage.putData(imageData, metadata: metadata).observe(.success) { (snapshot) in
            let imageUrl = snapshot.metadata?.downloadURL()?.absoluteString as! String
            let endpoint = "https://max-mdb-socials.herokuapp.com/posts/\(pid)"
            let requestParameters: [String : Any] = [
                "imageUrl": imageUrl
            ]
            Alamofire.request(endpoint, method: .patch, parameters: requestParameters, encoding: URLEncoding.default, headers: nil).responseJSON().done { response -> Void in
                beaverLog.info("Successfully updated new post \(text) to have imageUrl \(imageUrl)")
                } .catch { error in
                    beaverLog.error(error.localizedDescription)
            }
        }
    }
    
    static func fetchUser(id: String) -> Promise<SocialsUser> {
        return Promise { seal in
            let endpoint = "https://max-mdb-socials.herokuapp.com/users/\(id)"
            Alamofire.request(endpoint, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON().done { response -> Void in
                var json = JSON(response.json)
                if var result = json.dictionaryObject {
                    var interested = [String]()
                    if let rInterested = result["postsInterested"] {
                        for event in (rInterested as! Array<Any>)  {
                            interested.append(event as! String)
                        }
                        result["postsInterested"] = interested
                    }
                    var created = [String]()
                    if let rCreated = result["postsCreated"] {
                        for event in (rCreated as! Array<Any>) {
                            created.append(event as! String)
                        }
                        result["postsCreated"] = created
                    }
                    beaverLog.info(result)
                    if let user = SocialsUser(JSON: result) {
                        seal.fulfill(user)
                    }
                }
            }
        }
    }
    
    static func fetchPost(id: String) -> Promise<Post> {
        return Promise { seal in
            let endpoint = "https://max-mdb-socials.herokuapp.com/posts\(id)"
            Alamofire.request(endpoint, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON().done { response -> Void in
                var json = JSON(response.json)
                if var result = json.dictionaryObject {
                    var interested = [String]()
                    if let rInterested = result["membersInterested"] {
                        for event in (rInterested as! Array<Any>) {
                            interested.append(event as! String)
                        }
                        result["membersInterested"] = interested
                    }
                    beaverLog.info(result)
                    if let post = Post(JSON: result) {
                        seal.fulfill(post)
                    }
                }
            }
        }
    }
    
    static func fetchPosts() -> Promise<[Post]> {
        return Promise { seal in
            let endpoint = "https://max-mdb-socials.herokuapp.com/posts"
            Alamofire.request(endpoint, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON().done { response -> Void in
                let result = JSON(response.json)
                var posts = [Post]()
                for post in result {
                    let post = post.1.dictionaryObject!
                    if let post = Post(JSON: post) {
                        beaverLog.info("fetching Post: \(post.id!)")
                        posts.append(post)
                    }
                }
                seal.fulfill(posts)
                beaverLog.info("Finished fetching posts.")
            }
        }
    }
}
