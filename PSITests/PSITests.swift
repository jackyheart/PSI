//
//  PSITests.swift
//  PSITests
//
//  Created by Jacky Tjoa on 21/4/18.
//  Copyright © 2018 Jacky Tjoa. All rights reserved.
//

import Quick
import Nimble
import SwiftyJSON
@testable import PSI

class PSITests: QuickSpec {

    override func spec() {
        
        var psiData:PSIData!
        var viewController:ViewController!
        
        beforeEach() {
            psiData = PSIData()
            let bundle = Bundle(for: type(of: self))
            if let url = bundle.url(forResource:"sample", withExtension:"json") {
                do {
                    let jsonData = try Data(contentsOf: url)
                    let json = try JSON(data:jsonData)
                    psiData.parseJSON(json: json)
                } catch {
                    print(error)
                }
            }
            
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            viewController = storyboard.instantiateInitialViewController() as! ViewController
            _ = viewController.view
        }
        
        describe("onMapLoaded") {
            context("whenAnnotationsAreAdded") {
                
                it("shouldShowFiveAnnotations") {
                    viewController.addAnnotationsToMap(psiData: psiData)
                    expect(viewController.mapView.annotations.count).to(equal(5))
                }
                
                it("shouldContainsEastWestCentralNorthAndSouth") {
                    viewController.addAnnotationsToMap(psiData: psiData)
                    expect(viewController.mapView.annotations.map { $0.title??.lowercased() }).to(contain("west", "east", "central", "north", "south"))
                }
                
                it("shouldMatchValuesForEachRegion") {
                    viewController.addAnnotationsToMap(psiData: psiData)
                    let mapAnnotations = viewController.mapView.annotations as? [MapAnnotation]
                    let dataReadings = psiData.readings[Readings.psi_twenty_four_hourly.rawValue] as! [String:NSNumber]
                    
                    //West
                    let west = mapAnnotations?.filter({ $0.regionKey == Region.west.rawValue })
                    expect(west?.count).to(equal(1))
                    if let west = west {
                        if west.count > 0 {
                            expect(west[0].psi24Val) == dataReadings[Region.west.rawValue]?.floatValue
                        }
                    }
                    
                    //East
                    let east = mapAnnotations?.filter({ $0.regionKey == Region.east.rawValue })
                    expect(east?.count).to(equal(1))
                    if let east = east {
                        if east.count > 0 {
                            expect(east[0].psi24Val) == dataReadings[Region.east.rawValue]?.floatValue
                        }
                    }
                    
                    //Central
                    let central = mapAnnotations?.filter({ $0.regionKey == Region.central.rawValue })
                    expect(central?.count).to(equal(1))
                    if let central = central {
                        if central.count > 0 {
                            expect(central[0].psi24Val) == dataReadings[Region.central.rawValue]?.floatValue
                        }
                    }
                    
                    //North
                    let north = mapAnnotations?.filter({ $0.regionKey == Region.north.rawValue })
                    expect(north?.count).to(equal(1))
                    if let north = north {
                        if north.count > 0 {
                            expect(north[0].psi24Val) == dataReadings[Region.north.rawValue]?.floatValue
                        }
                    }
                    
                    //South
                    let south = mapAnnotations?.filter({ $0.regionKey == Region.south.rawValue })
                    expect(south?.count).to(equal(1))
                    if let south = south {
                        if south.count > 0 {
                            expect(south[0].psi24Val) == dataReadings[Region.south.rawValue]?.floatValue
                        }
                    }
                }
            }
        }
    }
}
