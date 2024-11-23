//
//  ActivityViewModel.swift
//  DailyActivityMonitorHomework2
//
//  Created by Your Name on 10/21/24.
//

import Foundation
import CoreData
import SwiftUI

class ActivityViewModel: ObservableObject {
    @Published var activities: [UserActivity] = []
    private var context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
        fetchActivities()
    }

    func insertActivity(date: Date, walking: Int, running: Int, sleeping: Int, food: Int) {
        let newActivity = UserActivityEntity(context: context)
        newActivity.id = UUID()
        newActivity.date = date
        newActivity.walkingMinutes = Int16(walking)
        newActivity.runningMinutes = Int16(running)
        newActivity.sleepingHours = Int16(sleeping)
        newActivity.foodCalories = Int16(food)
        
        saveContext()
        fetchActivities()
    }
    
    func fetchActivities() {
        let request: NSFetchRequest<UserActivityEntity> = UserActivityEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        do {
            let fetchedActivities = try context.fetch(request)
            self.activities = fetchedActivities.map { UserActivity(entity: $0) }
        } catch {
            print("Error fetching activities: \(error)")
        }
    }
    
    func fetchActivities(from startDate: Date, to endDate: Date) {
        let request: NSFetchRequest<UserActivityEntity> = UserActivityEntity.fetchRequest()
        request.predicate = NSPredicate(format: "date >= %@ AND date <= %@", startDate as NSDate, endDate as NSDate)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        do {
            let fetchedActivities = try context.fetch(request)
            self.activities = fetchedActivities.map { UserActivity(entity: $0) }
        } catch {
            print("Error fetching activities: \(error)")
        }
    }

    func clearData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = UserActivityEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
            saveContext()
            fetchActivities()
        } catch {
            print("Error clearing data: \(error)")
        }
    }

    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}
