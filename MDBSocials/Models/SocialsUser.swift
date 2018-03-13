//
//  User.swift
//  FirebaseDemoMaster
//
//  Created by Vidya Ravikumar on 9/22/17.
//  Copyright © 2017 Vidya Ravikumar. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit

class SocialsUser {
    var name: String?
    var email: String?
    var imageUrl: String?
    var id: String?
    var username: String?
    var stringsPostsInterested : [String]?
    
    init(id: String, userDict: [String:Any]?) {
        self.id = id
        if userDict != nil {
            if let name = userDict!["name"] as? String {
                self.name = name
            }
            if let imageUrl = userDict!["imageUrl"] as? String {
                self.imageUrl = imageUrl
            }
            if let email = userDict!["email"] as? String {
                self.email = email
            }
            if let username = userDict!["username"] as? String {
                self.username = username
            }
            if let postsInterested = userDict!["postsInterested"] as? [String]{
                self.stringsPostsInterested = postsInterested
            }
        }
    }
    
    static func getUser(withId: String) -> Promise<SocialsUser> {
        return FirebaseAPIClient.fetchUser(id: withId)
    }
    
    
}
