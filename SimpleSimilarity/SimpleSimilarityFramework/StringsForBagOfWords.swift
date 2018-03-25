//
//  StringsForBagOfWords.swift
//  SimpleSimilarityFramework
//
//  Created by Julius Bahr on 19.02.18.
//  Copyright © 2018 Julius Bahr. All rights reserved.
//

import Foundation

struct StringsForBagsOfWords {
    static private var stringsForBagOfWords: [Set<String>:[CorpusEntry]] = [:]
    
    static func strings(for bagOfWords: Set<String>) -> [CorpusEntry]? {
        return stringsForBagOfWords[bagOfWords]
    }
    
    static func add(corpusEntry: CorpusEntry) {
        let existingEntryForBagOfWords = stringsForBagOfWords[corpusEntry.bagOfWords]
        
        if var localExistingEntryForBagOfWords = existingEntryForBagOfWords {
            localExistingEntryForBagOfWords.append(corpusEntry)
            stringsForBagOfWords[corpusEntry.bagOfWords] = localExistingEntryForBagOfWords
        } else {
            stringsForBagOfWords[corpusEntry.bagOfWords] = [corpusEntry]
        }
    }
}
