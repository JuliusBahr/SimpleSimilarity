//
//  MatchingEngine.swift
//  SimpleSimilarityFramework
//
//  Created by Julius Bahr on 17.09.17.
//  Copyright © 2017 Julius Bahr. All rights reserved.
//

import Foundation

/// Error object thrown when the matching engine has not been filled with textual data
public struct MatchingEngineNotFilledError: Error {}

/// The result for a given query
public struct Result {
    let textualResult: TextualData
    let quality: UInt
}

fileprivate struct CorpusEntry {
    let textualData: TextualData
    let bagOfWords: Set<String>
}

open class MatchingEngine {

    fileprivate var isFilled = false

    fileprivate var allWords: NSCountedSet = NSCountedSet()

    public init() {
        
    }

    /// - Returns: a normalized represenation of the text corpus
    /// - Throws: a MatchingEngineNotFilledError when normalizedRepresentation() is called before fillMatchingEngine()
    /// - Precondition: you must first call fillMatchingEngine()
    open func normalizedRepresentation() throws -> [TextualData]  {
        return []
    }

    open func fillMatchingEngine(with corpus:[TextualData], completion: @escaping () -> Void) {
        print("Filling matching engine")

        DispatchQueue.global().async {
            var processedCorpus:[CorpusEntry] = []

            let stemmer = NSLinguisticTagger(tagSchemes: [.lemma], options: 0)

            // stem words
            corpus.forEach({ (textualData) in
                var tokenRanges: NSArray?
                stemmer.string = textualData.inputString
                let stemmedWords = stemmer.tags(in: NSRange(location: 0, length: textualData.inputString.utf16.count), unit: .word, scheme: .lemma, options: [.omitWhitespace, .omitOther, .omitPunctuation], tokenRanges: &tokenRanges)

                stemmedWords.forEach({ (tag) in
                    //tag.rawValue
                })

            })
            // remove infrequent and frequent words
            // sort string
            self.isFilled = true

            completion()
        }
    }

    /// Get the best result for the given query
    ///
    /// - Parameters:
    ///   - query: the query object for which the best match in the mathing engine is retrieved
    ///   - resultFound: closure that is called once the best result is found
    /// - Throws: a MatchingEngineNotFilledError when bestResult() is called before fillMatchingEngine()
    /// - Precondition: you must first call fillMatchingEngine()
    open func bestResult(for query:TextualData, resultFound:() -> Result) throws {
    }

}
