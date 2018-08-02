//
//  MatchingEngineTests.swift
//  SimpleSimilarityFrameworkTests
//
//  Created by Julius Bahr on 22.10.17.
//  Copyright © 2017 Julius Bahr. All rights reserved.
//

import XCTest
@testable import SimpleSimilarityFramework

class MatchingEngineLargeCorpusTests: XCTestCase {

    static var matchingEngine: MatchingEngine?

    override class func setUp() {
        super.setUp()

        setupMatchingEngineWithLargeInput() {} // this is less then ideal as the matching engine will be filled at least twice in parallel as we cannot block the first test to execute till the matching engine is filled
    }

    class func setupMatchingEngineWithLargeInput(completion: @escaping () -> Void) {
        if let localMatchingEngine = self.matchingEngine, localMatchingEngine.isFilled {
            completion()
            return
        }

        guard let csvPath = Bundle.main.path(forResource: "newspaper", ofType: "csv") else {
            return
        }

        var csvImporter = NewspaperCorpusImport()
        do {
            try csvImporter.loadFile(at: csvPath)
        } catch {
            print("Reading the csv file caused an exception.")
        }

        self.matchingEngine = MatchingEngine()

        guard let fileContents = csvImporter.fileContents else {
            return
        }

        self.matchingEngine!.fillMatchingEngine(with: fileContents, completion: completion)
    }
    
    func testQueryFoundInCorpusNotExhaustive() {

        let asyncExpectation = expectation(description: "asyncWait")
        
        MatchingEngineLargeCorpusTests.setupMatchingEngineWithLargeInput() {
            let yellowTailedTuna = TextualData(inputString: "Der Bundeskanzler reiste nach Algerien", origin: nil, originObject: nil)
            
            try? MatchingEngineLargeCorpusTests.matchingEngine?.bestResult(for: yellowTailedTuna, exhaustive: false, resultFound: { (result) in
                guard let result = result else {
                    XCTFail("No result found")
                    return
                }
                
                XCTAssertTrue(result.textualResults.first!.inputString.contains("Bundeskanzler"))
                
                XCTAssert(result.quality > 0.2)
                
                asyncExpectation.fulfill()
            })
        }
        
        waitForExpectations(timeout: 120)
    }
    
    func testQueryFoundInCorpusExhaustive() {

        let asyncExpectation = expectation(description: "asyncWait")
        
        MatchingEngineLargeCorpusTests.setupMatchingEngineWithLargeInput() {
            let expectedBestMatch = TextualData(inputString: "Das ist die wichtigste Lektion für Amerika aus dem Jahr 2002", origin: nil, originObject: nil)
            
            try? MatchingEngineLargeCorpusTests.matchingEngine?.bestResult(for: expectedBestMatch, exhaustive: true, resultFound: { (result) in
                guard let result = result else {
                    XCTFail("No result found")
                    return
                }
                
                XCTAssertTrue(result.textualResults.first!.inputString.contains("wichtigste"))
                XCTAssertTrue(result.textualResults.first!.inputString.contains("Lektion"))
                
                XCTAssert(result.quality > 0.75)
                
                asyncExpectation.fulfill()
            })
        }
        
        waitForExpectations(timeout: 60)
    }
    
    func testQueryNotFoundInCorpus() {
        
        let asyncExpectation = expectation(description: "asyncWait")
        
        MatchingEngineLargeCorpusTests.setupMatchingEngineWithLargeInput() {
            let noMatchQuery = TextualData(inputString: "great sashimi dish", origin: nil, originObject: nil)
            
            try? MatchingEngineLargeCorpusTests.matchingEngine?.bestResult(for: noMatchQuery, exhaustive: true, resultFound: { (result) in
                XCTAssertNil(result, "Result found where no result was expected")
                asyncExpectation.fulfill()
            })
        }
        
        waitForExpectations(timeout: 60)
    }

    func testZManySearches() {
        let asyncExpectation = expectation(description: "asyncWait")

        // get queries
        guard let csvPath = Bundle.main.path(forResource: "newspaper", ofType: "csv") else {
            return
        }

        var csvImporter = NewspaperCorpusImport()
        do {
            try csvImporter.loadFile(at: csvPath)
        } catch {
            print("Reading the csv file caused an exception.")
        }

        guard let fileContents = csvImporter.fileContents else {
            return
        }

        let queries = fileContents[0...100]

        MatchingEngineLargeCorpusTests.setupMatchingEngineWithLargeInput() {

            queries.forEach({ (query) in
                try? MatchingEngineLargeCorpusTests.matchingEngine?.bestResult(for: query, exhaustive: true, resultFound: { (result) in
                    if query.inputString.count > 3 {
                        XCTAssertNotNil(result, "We should find in the corpus what we previously added:\n query: \(query.inputString)")
                        XCTAssert(result?.quality ?? 0.0 > 0.98, "Result quality is too low: \(result?.quality)")
                    }
                })
            })

            asyncExpectation.fulfill()

        }

        waitForExpectations(timeout: 60)
    }
    
}
