//
//  Diary.swift
//  AutoTask
//
//  Created by Ali Ahmad Fahrezy on 04/06/25.
//

import Foundation
import SwiftData

@Model
class Diary {
    var id: UUID
    var content: String
    var timestamp: Date
    @Relationship var schedule: Schedule?
    @Relationship var goal: Goal?

    init(content: String, timestamp: Date = .now) {
        self.id = UUID()
        self.content = content
        self.timestamp = timestamp
    }
}
