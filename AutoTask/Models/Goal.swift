//
//  Goal.swift
//  AutoTask
//
//  Created by Ali Ahmad Fahrezy on 05/06/25.
//

import Foundation
import SwiftData

@Model
class Goal {
    var id: UUID
    var name: String
    var messages: [Diary] = []

    init(name: String) {
        self.id = UUID()
        self.name = name
    }
}
