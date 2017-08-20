//
//  SimpleSimilarityFrameworkTests.swift
//  SimpleSimilarityFrameworkTests
//
//  Created by Julius Bahr on 20.08.17.
//  Copyright © 2017 Julius Bahr. All rights reserved.
//

import XCTest
@testable import SimpleSimilarityFramework

class SimpleSimilarityFrameworkTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCsvImport() {
        let csvImporter = CSVImport()
        Bundle.main.path(forResource: "sample", ofType: "csv")
    }
    
}
