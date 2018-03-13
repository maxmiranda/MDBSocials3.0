//
//  Post.swift
//  FirebaseDemoMaster
//
//  Created by Vidya Ravikumar on 9/22/17.
//  Copyright © 2017 Vidya Ravikumar. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage
import ObjectMapper
import PromiseKit


class Post: Mappable {
    var text: String?
    var date: Date?
    var overallDateString: String?
    var dateString: String?
    var timeString: String?
    var description: String?
    var imageUrl: String?
    var posterId: String?
    var poster: String?
    var id: String?
    var image: UIImage?
    var numInterested: Int!
    var membersInterested: [String]!
    var latitude: Double?
    var longitude: Double?
    
    required init?(map: Map) {
        
    }
    func mapping(map: Map) { // have to look at what it's initialized with and make sure that you're covering everything, cuz I know you're not here
        id <- map["id"]
        numInterested <- map["numInterested"]
        description <- map["description"]
        posterId <- map["posterId"]
        poster <- map["poster"]
        membersInterested <- map["membersInterested"]
        text                          <- map["text"]
        overallDateString               <- map["date"]
        imageUrl <- map["imageUrl"]
        overallDateString <- map["date"]
        date = overallDateString?.toDate(dateFormat: "yyyy-MM-dd HH:mm:ss")
        dateString = Utils.createDateString(date: date!)
        timeString = Utils.createTimeString(date: date!)
        latitude <- map["latitude"]
        longitude <- map["longitude"]
    }
}
    
extension String {
    func toDate( dateFormat format  : String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        return dateFormatter.date(from: self)!
    }
}



