//
//  UserActivity.swift
//  DailyActivityMonitorHomework1
//
//  Created by Divanshu Chauhan on 11/23/24.
//

import Foundation
import CoreData

struct UserActivity: Identifiable {
    let id: UUID
    let date: Date
    let walkingMinutes: Int
    let runningMinutes: Int
    let sleepingHours: Int
    let foodCalories: Int

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }

    init(id: UUID, date: Date, walkingMinutes: Int, runningMinutes: Int, sleepingHours: Int, foodCalories: Int) {
        self.id = id
        self.date = date
        self.walkingMinutes = walkingMinutes
        self.runningMinutes = runningMinutes
        self.sleepingHours = sleepingHours
        self.foodCalories = foodCalories
    }

    init(entity: UserActivityEntity) {
        self.id = entity.id ?? UUID()
        self.date = entity.date ?? Date()
        self.walkingMinutes = Int(entity.walkingMinutes)
        self.runningMinutes = Int(entity.runningMinutes)
        self.sleepingHours = Int(entity.sleepingHours)
        self.foodCalories = Int(entity.foodCalories)
    }
}
