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

    func testMatchingEngineDidFill() {
        guard let csvPath = Bundle.main.path(forResource: "sample", ofType: "csv") else {
            return
        }

        var csvImporter = CSVImport()
        do {
            try csvImporter.loadFile(at: csvPath)
        } catch {
            print("Reading the csv file caused an exception.")
        }

        let matchingEngine = MatchingEngine()

        guard let fileContents = csvImporter.fileContents else {
            return
        }
        
        let asyncExpectation = expectation(description: "asyncWait")
        
        matchingEngine.fillMatchingEngine(with: fileContents) {
            XCTAssertTrue(matchingEngine.isFilled, "After loading the matching engine it needs to be filled")
            asyncExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 3)
    }

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

    func disabledTestDetermineFrequentAndInfrequentWordsEvenlyDistributed() {
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
    
    func testQueryFoundInCorpus() {
    
        guard let csvPath = Bundle.main.path(forResource: "sample", ofType: "csv") else {
            return
        }
        
        var csvImporter = CSVImport()
        do {
            try csvImporter.loadFile(at: csvPath)
        } catch {
            print("Reading the csv file caused an exception.")
        }
        
        let matchingEngine = MatchingEngine()
        
        guard let fileContents = csvImporter.fileContents else {
            return
        }
        
        let asyncExpectation = expectation(description: "asyncWait")
        
        matchingEngine.fillMatchingEngine(with: fileContents) {
            let yellowTailedTuna = TextualData(inputString: "yellow tailed tuna", origin: nil)
            
            try? matchingEngine.bestResult(for: yellowTailedTuna, exhaustive: false, resultFound: { (result) in
                guard let result = result else {
                    XCTFail("No result found")
                    return
                }
                
                XCTAssertTrue(result.textualResult.inputString.contains("yellow"))
                
                XCTAssert(result.quality > 0.5)
                
                asyncExpectation.fulfill()
            })
        }
        
        waitForExpectations(timeout: 3)
    }
    
    func testQueryNotFoundInCorpus() {
        
    }
    
    func testPreprocessStringSentence() {
        let matchingEngine = MatchingEngine()
        
        let preprocessedBagOfWods = matchingEngine.preprocess(string: "The quick brown fox did jump over the fences.")
        
        XCTAssertFalse(preprocessedBagOfWods.isEmpty)
        XCTAssertTrue(preprocessedBagOfWods.contains("do"))
        XCTAssertTrue(preprocessedBagOfWods.contains("quick"))
    }
    
    func testPreprocessStringConjugations() {
        let matchingEngine = MatchingEngine()
        
        let preprocessedBagOfWods1 = matchingEngine.preprocess(string: "I was going to the bakery.")
        let preprocessedBagOfWods2 = matchingEngine.preprocess(string: "They are going to the bakery.")
        let preprocessedBagOfWods3 = matchingEngine.preprocess(string: "We will be going to the bakery.")
        
        for bagOfWords in [preprocessedBagOfWods1, preprocessedBagOfWods2, preprocessedBagOfWods3] {
            XCTAssertFalse(bagOfWords.isEmpty)
            XCTAssertTrue(bagOfWords.contains("be"))
            XCTAssertTrue(bagOfWords.contains("go"))
            XCTAssertTrue(bagOfWords.contains("bakery"))
        }
    }
    
    func testPreprocessStringPlurals() {
        let matchingEngine = MatchingEngine()
        
        let preprocessedBagOfWods1 = matchingEngine.preprocess(string: "Joshua, let's go see the trains.")
        let preprocessedBagOfWods2 = matchingEngine.preprocess(string: "Let's do some train spotting.")
        let preprocessedBagOfWods3 = matchingEngine.preprocess(string: "From which station are trains leaving for Dover?")
        
        for bagOfWords in [preprocessedBagOfWods1, preprocessedBagOfWods2, preprocessedBagOfWods3] {
            XCTAssertFalse(bagOfWords.isEmpty)
            XCTAssertTrue(bagOfWords.contains("train"))
        }
    }
    
}
