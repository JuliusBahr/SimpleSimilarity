//
//  FirstViewController.swift
//  SimpleSimilarity
//
//  Created by Julius Bahr on 20.08.17.
//  Copyright © 2017 Julius Bahr. All rights reserved.
//

import UIKit
import SimpleSimilarityFramework

class FirstViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let csvPath = Bundle.main.path(forResource: "sample", ofType: "csv") else {
            return
        }

        var csvImporter = CSVImport()
        do {
            try csvImporter.loadFile(at: csvPath)
        } catch {
            print("Reading the csv file caused an exception.")
        }

        let matchingEngine = MatchingEngine()

        guard let fileContents = csvImporter.fileContents else {
            return
        }

        matchingEngine.fillMatchingEngine(with: fileContents) {

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

