//
//  PSIData.swift
//  PSI
//
//  Created by Jacky Tjoa on 21/4/18.
//  Copyright © 2018 Jacky Tjoa. All rights reserved.
//

import UIKit

class PSIData: NSObject {
    var status = ""
    var timestamp:String = ""
    var updatedTimestamp = ""
    
    func parseJSON(json: JSON) {
        
        //status
        self.status = json["api_info"]["status"].stringValue
        
        if json["items"].count > 0 {
            //timestamp
            let timestamp = json["items"][0]["timestamp"].stringValue
            self.timestamp = timestamp
            
            //updated timestamp
            let updatedTimestamp = json["items"][0]["update_timestamp"].stringValue
            self.updatedTimestamp = updatedTimestamp
        }
    }
}
