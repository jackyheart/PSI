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
    
    var psiData:PSIData!

    override func spec() {
        
        beforeEach() {
            self.psiData = PSIData()
            let bundle = Bundle(for: type(of: self))
            if let url = bundle.url(forResource:"sample", withExtension:"json") {
                do {
                    let jsonData = try Data(contentsOf: url)
                    let json = try JSON(data:jsonData)
                    self.psiData.parseJSON(json: json)
                } catch {
                    print(error)
                }
            }
        }
    }
}
