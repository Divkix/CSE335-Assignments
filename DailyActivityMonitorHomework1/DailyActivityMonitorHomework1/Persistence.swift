//
//  PersistenceController.swift
//  DailyActivityMonitorHomework1
//
//  Created by Divanshu Chauhan on 11/23/24.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "DailyActivityMonitor")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                // Handle error appropriately in a real app
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
