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
    
    func testStopwordRemovalWhereStopwordsAreContained() {
        let matchingEngine = MatchingEngine()
        
        let stopwords: Set = ["remove", "this"]
        
        let textualData1 = TextualData(inputString: "We want to remove this", origin: nil)
        let bagOfWords1: Set = ["we", "want", "to", "remove", "this"]
        
        let textualData2 = TextualData(inputString: "There is nothing to remove here", origin: nil)
        let bagOfWords2: Set = ["there", "is", "nothing", "to", "remove", "here"]
        
        let corpus = [CorpusEntry(textualData: textualData1, bagOfWords: bagOfWords1), CorpusEntry(textualData: textualData2, bagOfWords: bagOfWords2)]
        let processedCorpus = matchingEngine.remove(stopwords: stopwords, from: corpus)
        
        for corpusEntry in processedCorpus {
            let intersection = corpusEntry.bagOfWords.intersection(stopwords)
            XCTAssert(intersection.isEmpty, "After stopword removal the bag of words for a corpus entry must not contain a stopword")
            XCTAssert(corpusEntry.bagOfWords.count <= 6, "After stopwoprd removal the count of bag of words must be equal or lower than before")
        }
    }
    
}
