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
import ObjectMapper

class SocialsUser: Mappable {
    var name: String?
    var email: String?
    var imageUrl: String?
    var id: String?
    var username: String?
    var stringsPostsInterested : [String]?
    var stringsPostsCreated : [String]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) { 
        id <- map["id"]
        name <- map["name"]
        imageUrl <- map["imageUrl"]
        email <- map["email"]
        username <- map["username"]
        stringsPostsInterested <- map["postsInterested"]
        stringsPostsCreated <- map["postsCreated"]
    }
    init(id: String, userDict: [String:Any]?) {
        
    }
}
