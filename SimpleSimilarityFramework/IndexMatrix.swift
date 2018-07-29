//
//  IndexMatrix.swift
//  SimpleSimilarityFramework
//
//  Created by Julius Bahr on 29.07.18.
//  Copyright © 2018 Julius Bahr. All rights reserved.
//

import Foundation

class IndexMatrix {
    
    // only readable for testing
    private(set) var featureVectors: [[Int]] = Array()
    
    private let uniqueValuesArray: Array<AnyHashable>
    
    required init(uniqueValues: Set<AnyHashable>) {
        uniqueValuesArray = Array(uniqueValues)
    }
    
    func add(featureVector: [AnyHashable]) throws {
        // convert the feature vector to an array. We want this so that our feature vectors in the IndexMatrix have values at indices that are constantly growing: featureVector[i+1] > featureVector[i]
        
        var vectorOfIndices: [Int] = Array()
        
        try featureVector.forEach { (item) in
            guard let firstMatch = uniqueValuesArray.firstIndex(of: item) else {
                throw InvalidArgumentValueError()
            }
            
            vectorOfIndices.append(firstMatch)
        }
        
        featureVectors.append(vectorOfIndices.sorted())
    }
    
    func add(featureVector: Set<AnyHashable>) throws {
        let array = Array(featureVector)
        try add(featureVector: array)
    }
    
    // TODO: Implement
    func add(featureVectors: [[AnyHashable]]) {
        
    }
    
    private init() {
        uniqueValuesArray = []
    }

}
