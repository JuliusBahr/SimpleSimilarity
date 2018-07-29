//
//  ArrayOfIndicesTests.swift
//  SimpleSimilarityFrameworkTests
//
//  Created by Julius Bahr on 29.07.18.
//  Copyright © 2018 Julius Bahr. All rights reserved.
//

import XCTest
@testable import SimpleSimilarityFramework

class ArrayOfIndicesTests: XCTestCase {

    func testAddFeatureVectorWithSuccess() {
        let uniqueValues: Set = ["coffee", "beer", "wine", "water", "tonic water"]
        
        let arrayOfIndices = ArrayOfIndices(uniqueValues: uniqueValues)
        
        do {
            try arrayOfIndices.add(featureVector: ["coffee", "beer"])
        } catch {
            XCTFail()
        }
        
        XCTAssert(true)
    }
    
    func testAddFeatureVectorFailedTooMayElement() {
        let uniqueValues: Set = ["coffee", "beer", "wine", "water", "tonic water"]
        
        let arrayOfIndices = ArrayOfIndices(uniqueValues: uniqueValues)
        
        do {
            try arrayOfIndices.add(featureVector: ["coffee", "beer", "wine", "water", "tonic water", "potato"])
        } catch let error {
            XCTAssert(error is InvalidArgumentValueError)
            return
        }
        
        XCTAssert(false)
    }

}
