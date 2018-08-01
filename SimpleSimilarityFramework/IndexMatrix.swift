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

    // only readable for testing
    private(set) var featureVectors: [FeatureVector] = Array()
    
    private let uniqueValuesArray: Array<AnyHashable>


    /// Set up with the unique values
    ///
    /// - Parameter uniqueValues: the unique values set
    required init(uniqueValues: Set<AnyHashable>) {
        uniqueValuesArray = Array(uniqueValues)
    }

    private init() {
        uniqueValuesArray = []
    }


    /// Add a feature vector to the index matrix
    ///
    /// - Parameter featureVector: the feature vector to be added
    /// - Throws: an illegal argument exception when the feature vector has values that are not contained in the unique values
    func add(featureVector: FeatureVector) throws {
        var indexSet: Set<Int> = Set()
        var featureVectorCopy = featureVector
        
        try featureVectorCopy.features.forEach { (item) in
            guard let firstMatch = uniqueValuesArray.firstIndex(of: item) else {
                throw InvalidArgumentValueError()
            }
            
            indexSet.insert(firstMatch)
        }

        featureVectorCopy.indexSet = indexSet

        featureVectors.append(featureVectorCopy)
    }
    
    // TODO: Implement
    func add(featureVectors: [FeatureVector]) {
        
    }

    func bestResult(for query: FeatureVector, resultFound:(FeatureVector?) -> Void) {
        var bestMatchScore: Float32 = 0.0
        var bestMatch: FeatureVector? = nil
        let queryCount = query.features.count

        for featureVector in featureVectors {
            let intersectionCount = query.features.intersection(featureVector.features).count

            let score: Float32 = Float32(intersectionCount)/Float32(queryCount)
            if score > 0.99 {
                resultFound(featureVector)
                return
            }

            if score >= bestMatchScore {
                bestMatchScore = score
                bestMatch = featureVector
            }
        }

        resultFound(bestMatch)
    }

}
