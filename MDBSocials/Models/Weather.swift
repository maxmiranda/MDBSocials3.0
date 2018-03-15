//
//  File.swift
//  MDBSocials
//
//  Created by Max Miranda on 3/13/18.
//  Copyright © 2018 ___MaxAMiranda___. All rights reserved.
//

import Foundation
import ObjectMapper

class Weather : Mappable {
    
    int temperature: Int?
    init(weatherDictionary: [String: Any]) {
        temperature = weatherDictionary[
    }
}
