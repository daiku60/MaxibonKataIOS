//
//  KarumiHQsSpec.swift
//  MaxibonKataIOS
//
//  Created by Jordi Serra i Font on 25/3/17.
//  Copyright © 2017 GoKarumi. All rights reserved.
//

import XCTest
import Foundation
import SwiftCheck
@testable import MaxibonKataIOS

class KarumiHQsSpec: XCTestCase {
    
    func testNumberOfMaxibonsAreAlwaysGreaterThanTwo() {
        property("The number of maxibons should always be greater than 2")
            <- forAll(Developer.arbitraryNotSoHungry) { (developer: Developer) in
            let karumiHQ = KarumiHQs()
            karumiHQ.openFridge(developer)
            return karumiHQ.maxibonsLeft > 2
        }
        
        property("The number of maxibons should always be greater than 2", arguments: CheckerArguments(maxAllowableSuccessfulTests: 10))
            <- forAll() { (developers: ArrayOf<Developer>) in
                let karumiHQ = KarumiHQs()
                print("##### GROUP #####")
                print(developers.getArray)
                karumiHQ.openFridge(developers.getArray)
                return karumiHQ.maxibonsLeft > 2
        }
        
        property("When a hungry developer comes in, we always end up refilling the fridge and shouting it into slack")
            <- forAll(Developer.arbitraryHungry) { (developer: Developer) -> Testable in
                let chat = MockChat()
                let karumiHQs = KarumiHQs(chat: chat)
                karumiHQs.openFridge(developer)
                let expectedResult = (chat.messageSent == "Hi guys, I'm \(developer). We need more maxibons!")
                chat.messageSent = nil
                return expectedResult
        }
        
        property("When a not so hungry developer comes in, we never say anything", arguments: CheckerArguments(maxAllowableSuccessfulTests: 7))
            <- forAll(Developer.arbitraryNotSoHungry) { (developer: Developer) in
                let chat = MockChat()
                let karumiHQs = KarumiHQs(chat: chat)
                karumiHQs.openFridge(developer)
                let expectedResult = (chat.messageSent == nil)
                chat.messageSent = nil
                return expectedResult
        }
        
        property("When a group of hungry developer comes in, we always end up refilling the fridge and shouting it into slack")
            <- forAll(Developer.arbitraryHungry) { (developers: ArrayOf<Developer>) in
                let chat = MockChat()
                let karumiHQs = KarumiHQs(chat: chat)
                karumiHQs.openFridge(developer)
                let expectedResult = (chat.messageSent == "Hi guys, I'm \(developer). We need more maxibons!")
                chat.messageSent = nil
                return expectedResult
        }
        
    }
    
}

extension ArrayOf, where A : Developer {
    /// Returns a generator of `ArrayOf` values.
    public static var arbitraryHungry : Gen<ArrayOf<A>> {
        return Array<A>.arbitraryHungry.map(ArrayOf.init)
    }
}
