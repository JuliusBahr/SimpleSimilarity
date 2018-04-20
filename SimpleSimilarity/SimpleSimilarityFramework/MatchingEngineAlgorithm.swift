//
//  MatchingEngineAlgorithm.swift
//  SimpleSimilarityFramework
//
//  Created by Julius Bahr on 20.04.18.
//  Copyright © 2018 Julius Bahr. All rights reserved.
//

import Foundation

internal struct MatchingEngineAlgortihm {
    
    internal static func determineFrequentAndInfrequentWords(in set:NSCountedSet) -> Set<String> {
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
        let cutOffTop = Int(floor(Double(maxCount) * 0.9))
        // the bottom XX% of words are considered infrequent
        let cutOffBottom = Int(floor(Double(minCount) * 2.0))
        
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
    
    internal static func preprocess(string: String, stemmer: NSLinguisticTagger = NSLinguisticTagger(tagSchemes: [.lemma], options: 0)) -> Set<String> {
        
        var bagOfWords: Set<String> = Set()
        var tokenRanges: NSArray?
        
        stemmer.string = string
        let stemmedWords = stemmer.tags(in: NSRange(location: 0, length: string.utf16.count), unit: .word, scheme: .lemma, options: [.omitWhitespace, .omitOther, .omitPunctuation], tokenRanges: &tokenRanges)
        
        stemmedWords.forEach({ (tag) in
            let preprocessedWord = tag.rawValue.lowercased()
            if !preprocessedWord.isEmpty {
                bagOfWords.insert(preprocessedWord)
            }
        })
        
        return bagOfWords
    }
    
}
