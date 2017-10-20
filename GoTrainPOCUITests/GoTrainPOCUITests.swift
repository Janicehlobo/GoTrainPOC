//
//  GoTrainPOCUITests.swift
//  GoTrainPOCUITests
//
//  Created by Bahram Haddadi on 2017-10-12.
//  Copyright © 2017 Bahram Haddadi. All rights reserved.
//

import XCTest

class GoTrainPOCUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
//    func testExample() {
//        // Use recording to get started writing UI tests.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        let btn = app.buttons["btnPostToServer"]
//        btn.tap()
//        //XCTAssert(<#T##expression: Bool##Bool#>)
//    }
    
    func testCameraClick() {
        let app = XCUIApplication()
        
        app.buttons["btnCamera"].tap()
        let labelCamera = app.otherElements["Camera"]
        let labelPhotoLibrary = app.otherElements["Photo Library"]
        XCTAssert(!labelCamera.exists || !labelPhotoLibrary.exists)
    }
    
    func testbtnCamera(){
        let app = XCUIApplication()
        app.buttons["btnCamera"].tap()
        sleep(1)
        let sheet = app.sheets.firstMatch
        sheet.buttons["Camera"].tap()
        sleep(1)
        let alertLabel = app.otherElements["Camera is not available"]
        XCTAssert(!alertLabel.exists)
    }
    
    func testbtnPhotoLibrary(){
        let app = XCUIApplication()
        app.buttons["btnCamera"].tap()
        sleep(1)
        let sheet = app.sheets.firstMatch
        sheet.buttons["Photo Library"].tap()
        sleep(1)
        let alertLabel = app.otherElements["Photos"]
        XCTAssertNotNil(alertLabel.exists)
    }
    
    //TODO: please fix this test later
    func testEditbtn(){
        let app = XCUIApplication()
        app.buttons["btnCamera"].tap()
        sleep(1)
        let sheet = app.sheets.firstMatch
        sheet.buttons["Photo Library"].tap()
        sleep(1)
        
        let tableview = app.tables
        let firstCell = tableview.cells["Moments"]
        firstCell.tap()
        
        app.collectionViews["PhotosGridView"].cells["Photo, Landscape, August 08, 2012, 3:52 PM"].tap()
        
        let firstChild = app.collectionViews.children(matching:.any).element(boundBy: 0)
        if firstChild.exists {
            firstChild.staticTexts.element(boundBy: 0).tap()
//            firstChild.tap()
            
            sleep(2)
            let label = app.otherElements["Info"]
            XCTAssert(!label.exists)
        }
        
        XCTFail()
    }
    
    
}
