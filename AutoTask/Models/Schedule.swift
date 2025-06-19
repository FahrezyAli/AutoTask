//
//  Schedule.swift
//  AutoTask
//
//  Created by Ali Ahmad Fahrezy on 05/06/25.
//

import Foundation
import SwiftData

@Model
class Schedule {
    var id: UUID = UUID()
    var activity: String
    var date: Date
    var isCompleted: Bool = false
    var goal: String?

    init(activity: String, date: Date, goal: String?) {
        self.activity = activity
        self.date = date
        self.goal = goal
    }
}
