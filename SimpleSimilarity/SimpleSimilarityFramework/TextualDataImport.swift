//
//  TextualDataImport.swift
//  SimpleSimilarityFramework
//
//  Created by Julius Bahr on 20.08.17.
//  Copyright © 2017 Julius Bahr. All rights reserved.
//

import Foundation


/// Error object thrown when reading a file fails
struct FileReadError: Error {}

/// Data structure for a single textual input
struct TextualData {
    /// The input string
    let inputString: String

    /// The origin where this string is found. I.e. a book or a webpage or software
    let origin: String?
}


/// Base protocol used by objects that load data for the textual similarity search
protocol TextualDataImport {

    /// Load's the content of the given file
    ///
    /// - Parameter fileName: this file is being read
    /// - Throws: a FileReadError error when loading the file fails
    func loadFile(at fileName: String) throws

    /// The contents of the file that has been loaded
    /// - Precondition: a file must have been loaded before
    var fileContents: [TextualData]? {get}
}

struct CSVImport: TextualDataImport {
    fileprivate var csvFileContents: [TextualData]?

    var fileContents: [TextualData]? {
        get {
            return csvFileContents
        }
    }

    func loadFile(at fileName: String) throws {
        if FileManager.default.fileExists(atPath: fileName) {

            let fileContents = try? String(contentsOfFile: fileName)

            if let fileContents = fileContents {
                let lines = fileContents.split(separator: "\n")
                lines.forEach({ (line) in
                    let columns = line.split(separator: ";")
                    columns.forEach({ (column) in
                        debugPrint(column)
                    })
                })
            }
            
        } else {
            throw FileReadError()
        }
    }

}
