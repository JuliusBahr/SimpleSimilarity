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

/// Error object thrown when a parameter value is not within valid bounds
public struct InvalidArgumentValueError: Error {}

/// The result for a given query
public struct Result {
    public let textualResult: TextualData
    public let quality: UInt
}

/// A processed entry in the corpus
/// It contains the source string and the preprocessed representaion
open class CorpusEntry: Hashable {
    let textualData: TextualData
    var bagOfWords: Set<String>
    
    init(textualData: TextualData, bagOfWords: Set<String>) {
        self.textualData = textualData
        self.bagOfWords = bagOfWords
    }
    
    public var hashValue: Int {
        return textualData.hashValue
    }
    
    public static func ==(lhs: CorpusEntry, rhs: CorpusEntry) -> Bool {
        return lhs.textualData == rhs.textualData
    }
}

open class MatchingEngine {

    public private(set) var isFilled = false

    /// All words in the corpus with their occurence
    fileprivate var allWords: NSCountedSet = NSCountedSet()
    fileprivate var corpus: Set<CorpusEntry> = Set()

    public init() {
        
    }

    /// - Returns: a normalized represenation of the text corpus
    /// - Throws: a MatchingEngineNotFilledError when normalizedRepresentation() is called before fillMatchingEngine()
    /// - Precondition: you must first call fillMatchingEngine()
    open func normalizedRepresentation() throws -> [CorpusEntry]  {
        return []
    }

    open func fillMatchingEngine(with corpus:[TextualData], completion: @escaping () -> Void) {
        DispatchQueue.global().async {
            var processedCorpus: Set<CorpusEntry> = Set()

            let stemmer = NSLinguisticTagger(tagSchemes: [.lemma], options: 0)

            // stem words
            corpus.forEach({ (textualData) in

                var bagOfWords: Set<String> = Set()
                var tokenRanges: NSArray?

                stemmer.string = textualData.inputString
                let stemmedWords = stemmer.tags(in: NSRange(location: 0, length: textualData.inputString.utf16.count), unit: .word, scheme: .lemma, options: [.omitWhitespace, .omitOther, .omitPunctuation], tokenRanges: &tokenRanges)

                stemmedWords.forEach({ (tag) in
                    bagOfWords.insert(tag.rawValue)
                    self.allWords.add(tag.rawValue)
                })
                
                let newEntry = CorpusEntry(textualData: textualData, bagOfWords: bagOfWords)

                processedCorpus.insert(newEntry)
            })
            
            // determine frequent and infrequent words
            let stopwords = self.determineFrequentAndInfrequentWords(in: self.allWords)
            
            // remove infrequent and frequent words
            processedCorpus.forEach({ (corpusEntry) in
                corpusEntry.bagOfWords = corpusEntry.bagOfWords.subtracting(stopwords)
            })
            
            self.isFilled = true
            self.corpus = processedCorpus

            completion()
        }
    }

    func determineFrequentAndInfrequentWords(in set:NSCountedSet) -> Set<String> {
        var maxCount = 0
        var minCount = Int.max
        var medianCount = 0

        var stringsToRemove: Set<String> = []

        var stringCounts: [Int] = []

        set.objectEnumerator().allObjects.forEach { (string) in
            let stringCount = set.count(for: string)
            if stringCount > maxCount {
                maxCount = stringCount
            }
            if stringCount < minCount {
                minCount = stringCount
            }
            stringCounts.append(stringCount)
        }

        let sortedStringCounts = stringCounts.sorted()

        let stringCount = Double(sortedStringCounts.count)

        let midIndex = Int(floor(stringCount/2.0))
        medianCount = sortedStringCounts[midIndex]

        // the top 5% of words are considered frequent
        let cutOffTop = Int(floor(Double(maxCount) * 0.95))
        // the bottom 5% of words are considered infrequent
        let cutOffBottom = Int(floor(Double(maxCount) * 0.05))

        set.objectEnumerator().allObjects.forEach { (string) in
            guard string is String else {
                return
            }

            let stringCount = set.count(for: string)
            if stringCount > cutOffTop || stringCount < cutOffBottom {
                stringsToRemove.insert(string as! String)
            }
        }

        return stringsToRemove
    }

    /// Get the best result for the given query
    ///
    /// - Parameters:
    ///   - query: the query object for which the best match in the matching engine is retrieved
    ///   - exhaustive: the whole textual corpus is scanned, if is false only the first best match is returned
    ///   - resultFound: closure that is called once the best result is found
    /// - Throws: a MatchingEngineNotFilledError when bestResult() is called before fillMatchingEngine()
    /// - Precondition: you must first call fillMatchingEngine()
    open func bestResult(for query: TextualData, exhaustive: Bool, resultFound:() -> Result?) throws {
    }
    
    /// Get's the best results for a given query
    ///
    /// - Parameters:
    ///   - betterThan: the threshold for the quality of results. Valid results are within in 0.0 and 1.0
    ///   - query: the query object for which the best match in the matching engine is retrieved
    ///   - resultsFound: closure called when the matches with a quality higher than betterThan are found
    /// - Throws: a MatchingEngineNotFilledError when bestResult() is called before fillMatchingEngine(), a InvalidArgumentValueError when betterThan has an illegal value
    /// - Precondition: you must first call fillMatchingEngine()
    open func result(betterThan: Float, for query: String, resultsFound:() -> [Result]?) throws {
        
    }

}
