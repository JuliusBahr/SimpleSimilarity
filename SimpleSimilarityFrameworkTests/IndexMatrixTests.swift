//
//  IndexMatrixTests.swift
//  SimpleSimilarityFrameworkTests
//
//  Created by Julius Bahr on 29.07.18.
//  Copyright © 2018 Julius Bahr. All rights reserved.
//

import XCTest
@testable import SimpleSimilarityFramework


class IndexMatrixTests: XCTestCase {

    static let uniqueValuesBeverages: Set = ["coffee", "beer", "wine", "water", "tonic water", "cider"]

    func testAddFeatureVectorWithSuccess() {
        let indexMatrix = IndexMatrix(uniqueValues: IndexMatrixTests.uniqueValuesBeverages)
        
        do {
            try indexMatrix.add(featureVector: IndexMatrix.FeatureVector(features:["coffee", "beer"]))
        } catch {
            XCTFail()
        }
        
        XCTAssert(true)
    }
    
    func testAddFeatureVectorFailedTooMayElement() {
        let indexMatrix = IndexMatrix(uniqueValues: IndexMatrixTests.uniqueValuesBeverages)
        
        do {
            try indexMatrix.add(featureVector: IndexMatrix.FeatureVector(features: ["coffee", "beer", "wine", "water", "tonic water", "potato"]))
        } catch let error {
            XCTAssert(error is InvalidArgumentValueError)
            return
        }
        
        XCTAssert(false)
    }
    
    func testAddFeatureVectorFailedNonmatchingElements() {
        let indexMatrix = IndexMatrix(uniqueValues: IndexMatrixTests.uniqueValuesBeverages)
        
        do {
            try indexMatrix.add(featureVector: IndexMatrix.FeatureVector(features: ["hay", "barn", "wine"]))
        } catch let error {
            XCTAssert(error is InvalidArgumentValueError)
            return
        }
        
        XCTAssert(false)
    }
    
    func testCorrectLengthOfFeatureVector() {
        let indexMatrix = IndexMatrix(uniqueValues: IndexMatrixTests.uniqueValuesBeverages)
        
        try? indexMatrix.add(featureVector: IndexMatrix.FeatureVector(features: ["coffee", "beer", "wine"]))
        
        guard let featureVector = indexMatrix.featureVectors.first else {
            XCTAssert(false)
            return
        }
        
        XCTAssert(featureVector.features.count == 3)
        
        try? indexMatrix.add(featureVector: IndexMatrix.FeatureVector(features: ["tonic water", "cider"]))
        
        guard let featureVectorTwo = indexMatrix.featureVectors.last else {
            XCTAssert(false)
            return
        }
        
        XCTAssert(featureVectorTwo.features.count == 2)
    }


}
