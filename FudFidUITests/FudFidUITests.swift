//
//  FudFidUITests.swift
//  FudFidUITests
//
//  Created by Kate Roberts on 24/05/2020.
//  Copyright © 2020 SaLT for my Squid. All rights reserved.
//

import XCTest

class FudFidUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let app = XCUIApplication()
        setupSnapshot(app)
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    func walkthrough() throws{
       let app = XCUIApplication()
        app.children(matching: .window).element(boundBy: 4).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 2).tap()
        snapshot("01")
        let heartButton = app.buttons["heart"]
        heartButton.swipeLeft()
        heartButton.swipeLeft()
        heartButton.swipeLeft()
        snapshot("02")
        heartButton.swipeLeft()
        app.buttons["hand.raised.slash"].tap()
        snapshot("03")
        app.alerts["Don't Want This?"].scrollViews.otherElements.buttons["OK"].tap()
        app.alerts["Thank you"].scrollViews.otherElements.buttons["OK"].tap()
        
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Add"].tap()
        snapshot("04")
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.swipeDown()
        tabBarsQuery.buttons["Feed "].tap()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}

