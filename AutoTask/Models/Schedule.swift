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
    var id: UUID
    var activity: String
    var time: Date
    var message: Diary?

    init(activity: String, time: Date) {
        self.id = UUID()
        self.activity = activity
        self.time = time
    }
}
