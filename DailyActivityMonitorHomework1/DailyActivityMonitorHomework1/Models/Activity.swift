//
//  Activity.swift
//  DailyActivityMonitorHomework1
//
//  Created by Divanshu Chauhan on 10/21/24.
//

import Foundation

struct Activity: Identifiable {
    let id = UUID()
    var date: Date
    var walkingMinutes: Int
    var runningMinutes: Int
    var sleepingHours: Int
    var foodCalories: Int
}
