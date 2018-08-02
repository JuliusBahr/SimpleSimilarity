//
//  IndexMatrix.swift
//  SimpleSimilarityFramework
//
//  Created by Julius Bahr on 29.07.18.
//  Copyright © 2018 Julius Bahr. All rights reserved.
//

import Foundation

/// A matrix with a column of unique values and feature vectors containing the indicies when a match to the column of values occurs
class IndexMatrix {

    /// A single feature vector
    struct FeatureVector {
        /// Hashable objects that can be added to an IndexMatrix
        let features: Set<AnyHashable>

        /// A back pointer to the original object that maps to these features
        weak var objectOrigin: AnyObject?

        fileprivate var indexSet: Set<Int>? // TODO: move to native IndexSet

        init(origin: AnyObject? = nil, features: Set<AnyHashable>) {
            self.objectOrigin = origin
            self.features = features
        }
    }

    struct SearchResult {
        let matchingFeatureVector: FeatureVector

        /// The score for this search result. The value is between 0.0 and 1.0
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
        var indexSet: Set<Int> = Set()
        var featureVectorCopy = featureVector
        
        try featureVectorCopy.features.forEach { (item) in
            guard let match = uniqueValuesDict[item] else {
                throw InvalidArgumentValueError()
            }
            
            indexSet.insert(match)
        }

        featureVectorCopy.indexSet = indexSet

        featureVectors.append(featureVectorCopy)
    }
    
    // TODO: Implement
    func add(featureVectors: [FeatureVector]) {
        
    }

    func bestResult(for query: FeatureVector, resultFound:(SearchResult?) -> Void) {
        var bestMatchScore: Float32 = 0.0
        var bestMatch: FeatureVector? = nil
        let queryCount = query.features.count

        for featureVector in featureVectors {
            let intersectionCount = query.features.intersection(featureVector.features).count

            let score: Float32 = Float32(intersectionCount)/Float32(queryCount)
            if score > 0.99 {
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

}
