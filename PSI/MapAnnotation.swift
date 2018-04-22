//
//  MapAnnotation.swift
//  PSI
//
//  Created by Jacky Tjoa on 21/4/18.
//  Copyright © 2018 Jacky Tjoa. All rights reserved.
//

import MapKit

class MapAnnotation: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    var psi24Val:Float = 0
    var regionKey = ""
    
    var markerTintColor: UIColor {
        switch psi24Val {
        case 0...50:
            return .green
        case 51...100:
            return .blue
        case 101...200:
            return .yellow
        case 201...300:
            return .orange
        default:
            return .red
        }
    }
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        regionKey = title.lowercased()
        
        super.init()
    }
}
