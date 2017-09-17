//
//  MatchingEngine.swift
//  SimpleSimilarityFramework
//
//  Created by Julius Bahr on 17.09.17.
//  Copyright © 2017 Julius Bahr. All rights reserved.
//

import Foundation

/// Error object thrown when the matching engine has not been filled with textual data
struct MatchingEngineNotFilledError: Error {}


/// The result for a given query
struct Result {
    let textualResult: TextualData
    let quality: UInt
}

class MatchingEngine {

    fileprivate var isFilled = false

    /// - Returns: a normalized represenation of the text corpus
    /// - Throws: a MatchingEngineNotFilledError when normalizedRepresentation() is called before fillMatchingEngine()
    /// - Precondition: you must first call fillMatchingEngine()
    func normalizedRepresentation() throws -> [TextualData]  {
        return []
    }

    func fillMatchingEngine(with corpus:[TextualData], completion:() -> Void) {
        DispatchQueue.global().async {
            let stemmer = NSLinguisticTagger(tagSchemes: [.lemma], options: 0)

            corpus.forEach({ (textualData) in
                let stemmedWords = stemmer.tags(in: NSRange(location: 0, length: textualData.inputString.count-1), unit: .sentence, scheme: .lemma, options: [.omitWhitespace, .omitOther, .omitPunctuation], tokenRanges: nil)
            })
            // stem words
            // remove infrequent and frequent words
            // sort string

        }
    }

    /// Get the best result for the given query
    ///
    /// - Parameters:
    ///   - query: the query object for which the best match in the mathing engine is retrieved
    ///   - resultFound: closure that is called once the best result is found
    /// - Throws: a MatchingEngineNotFilledError when bestResult() is called before fillMatchingEngine()
    /// - Precondition: you must first call fillMatchingEngine()
    func bestResult(for query:TextualData, resultFound:() -> Result) throws {
    }

}
