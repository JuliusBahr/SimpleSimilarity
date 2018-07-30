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

        fileprivate var indexSet: Set<Int>?

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

}
