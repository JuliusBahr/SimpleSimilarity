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
        guard let csvPath = Bundle.main.path(forResource: "sample", ofType: "csv") else {
            XCTFail("CSV file could not be read.")
            return
        }

        var csvImporter = CSVImport()
        do {
            try csvImporter.loadFile(at: csvPath)
        } catch {
            XCTFail("Reading the csv file caused an exception.")
        }

    }

    func testCsvImportMatchesOutput() {
        guard let csvPath = Bundle.main.path(forResource: "sample", ofType: "csv") else {
            XCTFail("CSV file could not be read.")
            return
        }

        var csvImporter = CSVImport()
        do {
            try csvImporter.loadFile(at: csvPath)
        } catch {
            XCTFail("Reading the csv file caused an exception.")
        }

        XCTAssertNotNil(csvImporter.fileContents)

        XCTAssertEqual(csvImporter.fileContents?.first?.inputString, "String")
        XCTAssertEqual(csvImporter.fileContents?.first?.origin, "Origin")
        XCTAssertEqual(csvImporter.fileContents?[1].inputString, "The quick brown fox jumped over the bridge")
        XCTAssertEqual(csvImporter.fileContents?[1].origin, "Book")
    }
}
