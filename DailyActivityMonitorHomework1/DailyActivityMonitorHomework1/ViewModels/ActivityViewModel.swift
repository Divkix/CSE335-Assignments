//
//  ActivityViewModel.swift
//  DailyActivityMonitorHomework1
//
//  Created by Divanshu Chauhan on 10/21/24.
//

import Foundation
import SwiftUI

struct UserActivity: Identifiable {
    let id = UUID()
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
}

class ActivityViewModel: ObservableObject {
    @Published var activities: [UserActivity] = []

    func insertActivity(date: Date, walking: Int, running: Int, sleeping: Int, food: Int) {
        let newActivity = UserActivity(
            date: date,
            walkingMinutes: walking,
            runningMinutes: running,
            sleepingHours: sleeping,
            foodCalories: food
        )
        if activities.count >= 7 {
            activities.removeFirst()
        }
        activities.append(newActivity)
        // Sort activities by date
        activities.sort { $0.date < $1.date }
    }

    func clearData() {
        activities.removeAll()
    }

    var healthStatus: String {
        let totalCaloriesBurned = activities.reduce(0.0) { result, activity in
            let walkingCalories = Double(activity.walkingMinutes) / 5.0 * 25.0
            let runningCalories = Double(activity.runningMinutes) / 5.0 * 50.0
            return result + walkingCalories + runningCalories
        }

        let totalCaloriesIntake = activities.reduce(0.0) { result, activity in
            result + Double(activity.foodCalories)
        }

        let averageCaloriesBurned = totalCaloriesBurned / max(Double(activities.count), 1.0)
        let averageCaloriesIntake = totalCaloriesIntake / max(Double(activities.count), 1.0)

        let recommendedCalorieIntake = 2250.0
        let caloriesDiff = averageCaloriesIntake - (averageCaloriesBurned + recommendedCalorieIntake)

        if caloriesDiff > 0.1 * recommendedCalorieIntake {
            return "You are gaining weight!"
        } else if abs(caloriesDiff) <= 0.1 * recommendedCalorieIntake {
            return "You have a healthy lifestyle!"
        } else {
            return "You are eating less!"
        }
    }
}
