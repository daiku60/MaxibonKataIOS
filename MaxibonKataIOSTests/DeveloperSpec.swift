//
//  DeveloperSpec.swift
//  
//
//  Created by Jordi Serra i Font on 25/3/17.
//
//

import XCTest
import Foundation
import SwiftCheck
@testable import MaxibonKataIOS

class DeveloperSpec: XCTestCase {
    
    func testTheNumberOfMaxibonsPerKarumieAre() {
        XCTAssert(Karumies.Pedro.numberOfMaxibonsToGet == 3)
        XCTAssert(Karumies.Davide.numberOfMaxibonsToGet == 0)
        XCTAssert(Karumies.Alberto.numberOfMaxibonsToGet == 1)
        XCTAssert(Karumies.Jorge.numberOfMaxibonsToGet == 2)
        XCTAssert(Karumies.Sergio.numberOfMaxibonsToGet == 1)
        XCTAssert(Karumies.Fran.numberOfMaxibonsToGet == 1)
    }
    
    func testAll() {
        property("Number of maxibons cannot be negative") <- forAll { (developer: Developer) in
            print(developer)
            return developer.numberOfMaxibonsToGet >= 0
        }
    }
   
}
