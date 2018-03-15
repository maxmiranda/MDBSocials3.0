//
//  DarkSkyAPI.swift
//  MDBSocials
//
//  Created by Max Miranda on 3/12/18.
//  Copyright © 2018 ___MaxAMiranda___. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import PromiseKit

class DarkSkyAPI {
    
    static func getCurrentWeather(latitude: Double, longitude: Double) -> Promise<NSNumber>  {
        let forecastAPIKey: String
        let APIKey = "27be80138724e7f08e3879f346fc1622"
        let forecastBaseURL = "https://api.darksky.net/forecast/\(APIKey)"
        return Promise { seal in
            if let forecastURL = URL(string: "\(forecastBaseURL)/\(latitude),\(longitude)") {
                Alamofire.request(forecastURL).responseJSON(completionHandler: {(response) in
                    if let jsonDictionary = response.result.value as? [String: Any] {
                        if let currentWeatherDictionary = jsonDictionary["currently"] as? [String: Any] {
                            seal.fulfill(currentWeatherDictionary["temperature"] as! NSNumber)
                            beaverLog.info("Received \(currentWeatherDictionary["temperature"]!) degrees as temperature in call to DarkSky.")
                        }
                    }
                })
            }
        }
    }
    
    
}
