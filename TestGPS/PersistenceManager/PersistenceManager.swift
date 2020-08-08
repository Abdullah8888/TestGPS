//
//  PersistenceManager.swift
//  TestGPS
//
//  Created by Jimoh Babatunde  on 07/08/2020.
//  Copyright © 2020 Tunde. All rights reserved.
//

import Foundation
import MagicalRecord

public class PersistenceManager: NSObject {
    
    public static let sharedManager = PersistenceManager()
    private var coordinateData : CoordinateData!
    
    public func setupDataStack() {
        MagicalRecord.setupCoreDataStack(withStoreNamed: "TestGPSDataModel")
        
    }

    //MARK: CoordinateData
    public func saveCoordinateData(_ latitude: String, _ longitude: String) {
        self.coordinateData = CoordinateData.mr_createEntity()
        self.coordinateData.latitude = latitude
        self.coordinateData.longitude = longitude
        self.saveContext()
    }

    public func saveContext() {
        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
    }
    
    public func getAll() -> [[String: String]] {
        let coordinateData =  CoordinateData.mr_findAll()
        var corArray : [[String: String]] = []
        if let data = coordinateData {
            if data.count > 0 {
                data.forEach { (obj) in
                    let obj1 = obj as! CoordinateData
                    let dict = ["lat" : obj1.latitude!, "lng": obj1.longitude!]
                
                    corArray.append(dict)
                }
            }
        }
       
       return corArray
    }
    
    public func clearData() {
        CoordinateData.mr_truncateAll()
        self.saveContext()
    }
}
