//
//  PSIData.swift
//  PSI
//
//  Created by Jacky Tjoa on 21/4/18.
//  Copyright © 2018 Jacky Tjoa. All rights reserved.
//

import SwiftyJSON

enum Readings:String {
    case psi_twenty_four_hourly = "psi_twenty_four_hourly"
}

enum Region:String {
    case east = "east"
    case west = "west"
    case central = "central"
    case north = "north"
    case south = "south"
    case national = "national"
}

class RegionMetadata {
    var name = ""
    var latitude:Double = 0.0
    var longitude:Double = 0.0
    
    init(name:String, latitude:String, longitude:String) {
        self.name = name
        if let lat = Double(latitude) {
            self.latitude = lat
        }
        
        if let long = Double(longitude) {
            self.longitude = long
        }
    }
}

class PSIData {
    var status = ""
    var readings:[String:Any] = [:]
    var timestamp = ""
    var updatedTimestamp = ""
    var regionMetadata:[RegionMetadata] = []
    
    func parseJSON(json: JSON) {
        
        //status
        self.status = json["api_info"]["status"].stringValue
        
        if json["items"].count > 0 {
            
            //readings
            if let readings = json["items"][0]["readings"].dictionaryObject {
                self.readings = readings
            }
            
            //timestamp
            let timestamp = json["items"][0]["timestamp"].stringValue
            self.timestamp = timestamp
            
            //updated timestamp
            let updatedTimestamp = json["items"][0]["update_timestamp"].stringValue
            self.updatedTimestamp = updatedTimestamp
        }
        
        //region metadata
        let regionMetadataArr = json["region_metadata"].arrayValue
        for region in regionMetadataArr {
            let name = region["name"].stringValue
            let latitudeStr = region["label_location"]["latitude"].stringValue
            let longitudeStr = region["label_location"]["longitude"].stringValue
            let regionMetadata = RegionMetadata(name: name, latitude: latitudeStr, longitude: longitudeStr)
            self.regionMetadata.append(regionMetadata)
        }
    }
}
