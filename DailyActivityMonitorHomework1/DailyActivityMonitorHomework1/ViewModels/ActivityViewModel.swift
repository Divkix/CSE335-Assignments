//
//  ActivityViewModel.swift
//  DailyActivityMonitorHomework1
//
//  Created by Divanshu Chauhan on 10/21/24.
//

import Foundation
import SwiftUI

class ActivityViewModel: ObservableObject {
    @Published var activities: [Activity] = []
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    func insertActivity(walking: Int, running: Int, sleeping: Int, food: Int) {
        let newActivity = Activity(date: Date(), walkingMinutes: walking, runningMinutes: running, sleepingHours: sleeping, foodCalories: food)
        if activities.count >= 7 {
            activities.removeFirst()
        }
        activities.append(newActivity)
    }
    
    func clearData() {
        activities.removeAll()
    }
    
    var healthStatus: String {
        let totalCaloriesBurned = activities.reduce(0) { result, activity in
            result + (activity.walkingMinutes / 5 * 25) + (activity.runningMinutes / 5 * 50)
        }
        let totalCaloriesIntake = activities.reduce(0) { result, activity in
            result + activity.foodCalories
        }
        let averageCaloriesBurned = totalCaloriesBurned / max(activities.count, 1)
        let averageCaloriesIntake = totalCaloriesIntake / max(activities.count, 1)
        
        let recommendedCaloryIntake = 2250
        let caloriesDiff = Double(averageCaloriesIntake) - Double(averageCaloriesBurned + recommendedCaloryIntake)
        
        if caloriesDiff > 0.1 * Double(recommendedCaloryIntake) {
            return "You are gaining weight!"
        } else if abs(caloriesDiff) <= 0.1 * Double(recommendedCaloryIntake) {
            return "You have a healthy lifestyle!"
        } else {
            return "You are eating less!"
        }
    }
}
