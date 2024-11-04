//
//  Item.swift
//  MyTravelJournalLab7
//
//  Created by Divanshu Chauhan on 11/4/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
