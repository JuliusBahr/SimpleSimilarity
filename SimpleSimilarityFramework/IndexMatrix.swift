//
//  IndexMatrix.swift
//  SimpleSimilarityFramework
//
//  Created by Julius Bahr on 29.07.18.
//  Copyright © 2018 Julius Bahr. All rights reserved.
//

import Foundation

/// A matrix with a column of unique values and feature vectors containing the indicies when a match to the column of unique values occurs
class IndexMatrix {

    /// A single feature vector
    struct FeatureVector {
        /// Hashable objects that can be added to an IndexMatrix
        let features: Set<AnyHashable>

        /// A back pointer to the original object that maps to these features
        weak var objectOrigin: AnyObject?

        fileprivate var indexSet: IndexSet?

        init(origin: AnyObject? = nil, features: Set<AnyHashable>) {
            self.objectOrigin = origin
            self.features = features
        }
    }


    /// A search result from the index matrix
    struct SearchResult {
        /// The found feature vector
        let matchingFeatureVector: FeatureVector

        /// The score for this search result. The value is between 0.0 and 1.0.
        let score: Float32
    }

    // only readable for testing
    private(set) var featureVectors: [FeatureVector] = Array()
    
    private var uniqueValuesDict: Dictionary<AnyHashable, Int> = Dictionary()

    /// Set up with the unique values
    ///
    /// - Parameter uniqueValues: the unique values set
    required init(uniqueValues: Set<AnyHashable>) {
        uniqueValuesDict = Dictionary(minimumCapacity: uniqueValues.count)

        var i: Int = 0
        uniqueValues.forEach { (hashable) in
            uniqueValuesDict[hashable] = i
            i += 1
        }
    }

    private init() {
    }

    /// Add a feature vector to the index matrix
    ///
    /// - Parameter featureVector: the feature vector to be added
    /// - Throws: an illegal argument exception when the feature vector has values that are not contained in the unique values
    func add(featureVector: FeatureVector) throws {
        var indexSet = IndexSet()
        var featureVectorCopy = featureVector
        
        try featureVectorCopy.features.forEach { (item) in
            guard let match = uniqueValuesDict[item] else {
                throw InvalidArgumentValueError()
            }
            
            indexSet.insert(match) // TODO: a map could be faster here
        }

        featureVectorCopy.indexSet = indexSet

        featureVectors.append(featureVectorCopy)
    }
    
    // TODO: Implement
    func add(featureVectors: [FeatureVector]) {
        
    }

    /// Returns the best result found in the index matrix
    ///
    /// - Parameters:
    ///   - query: the query to search for
    ///   - resultFound: called when a result has been found
    /// - Note: If a very good result is found this result is returned and the search is stopped.
    func bestResult(for query: FeatureVector, resultFound:(SearchResult?) -> Void) {
        var bestMatch: FeatureVector? = nil
        var bestMatchScore: Float32 = 0.0
        let queryCount = query.features.count

        // TODO: This screams for parallel execution
        for featureVector in featureVectors {
            let intersectionCount = query.features.intersection(featureVector.features).count

            let score: Float32 = Float32(intersectionCount)/Float32(queryCount)
            if score > 0.98 {
                resultFound(SearchResult(matchingFeatureVector: featureVector, score: score))
                return
            }

            if score > bestMatchScore {
                bestMatchScore = score
                bestMatch = featureVector
            }
        }

        if let bestMatch = bestMatch {
            resultFound(SearchResult(matchingFeatureVector: bestMatch, score: bestMatchScore))
        } else {
            resultFound(nil)
        }
    }

    /// Get's the best results for a given query
    ///
    /// - Parameters:
    ///   - betterThan: the threshold for the quality of results. Valid results are within in 0.0 and 1.0.
    ///   - query: the query object for which the best matchs in the index matrix are retrieved
    ///   - resultsFound: closure called when the matches with a quality higher than betterThan are found
    func results(betterThan: Float, for query: FeatureVector, resultsFound:([SearchResult]?) -> Void) {

        var matchesBetterThan: [SearchResult] = Array()
        let queryCount = query.features.count

        // TODO: This screams for parallel execution
        for featureVector in featureVectors {
            let intersectionCount = query.features.intersection(featureVector.features).count

            let score: Float32 = Float32(intersectionCount)/Float32(queryCount)

            if score >= betterThan {
                matchesBetterThan.append(SearchResult(matchingFeatureVector: featureVector, score: score))
            }
        }

        matchesBetterThan.count == 0 ? resultsFound(nil) : resultsFound(matchesBetterThan)
    }
}
