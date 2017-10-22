//
//  MatchingEngineTests.swift
//  SimpleSimilarityFrameworkTests
//
//  Created by Julius Bahr on 22.10.17.
//  Copyright © 2017 Julius Bahr. All rights reserved.
//

import XCTest
@testable import SimpleSimilarityFramework

class MatchingEngineTests: XCTestCase {

//    func testMatchingEngineDidFill() {
//        guard let csvPath = Bundle.main.path(forResource: "sample", ofType: "csv") else {
//            return
//        }
//
//        var csvImporter = CSVImport()
//        do {
//            try csvImporter.loadFile(at: csvPath)
//        } catch {
//            print("Reading the csv file caused an exception.")
//        }
//
//        let matchingEngine = MatchingEngine()
//
//        guard let fileContents = csvImporter.fileContents else {
//            return
//        }
//
//        matchingEngine.fillMatchingEngine(with: fileContents) {
//
//        }
//    }

    func testDetermineFrequentAndInfrequentWordsRegularCase() {
        let matchingEngine = MatchingEngine()

        let bagOfWords = NSCountedSet()

        for step in [3, 5, 10, 20, 30, 40, 50, 60, 70, 80, 90, 110, 120] {
            for _ in 0..<step {
                bagOfWords.add(String(step))
            }
        }

        let commonWords = matchingEngine.determineFrequentAndInfrequentWords(in: bagOfWords)
        XCTAssert(!commonWords.contains("30"))
        XCTAssert(!commonWords.contains("60"))
        XCTAssert(commonWords.contains("3"))
        XCTAssert(commonWords.contains("120"))
        XCTAssert(!commonWords.contains("was never added"))
    }

    func testDetermineFrequentAndInfrequentWordsEvenlyDistributed() {
        let matchingEngine = MatchingEngine()

        let bagOfWords = NSCountedSet()

        for step in [10, 10, 10, 10] {
            let randomNumberForStep = Int(arc4random())

            for _ in 0..<step {
                bagOfWords.add(String(randomNumberForStep))
            }
        }

        let commonWords = matchingEngine.determineFrequentAndInfrequentWords(in: bagOfWords)
        XCTAssert(commonWords.isEmpty)
    }
    
}