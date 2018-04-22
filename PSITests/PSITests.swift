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
            }
        }
    }
}
