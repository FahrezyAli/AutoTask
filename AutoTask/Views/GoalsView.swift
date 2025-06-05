//
//  GoalsView.swift
//  AutoTask
//
//  Created by Ali Ahmad Fahrezy on 05/06/25.
//

import SwiftData
import SwiftUI

struct GoalsView: View {
    @Query private var goals: [Goal]

    var body: some View {
        NavigationView {
            List(goals) { goal in
                Text(goal.name)
            }
            .navigationTitle("Goals")
        }
        .enableInjection()
    }

    #if DEBUG
        @ObserveInjection var forceRedraw
    #endif
}

#Preview {
    GoalsView().modelContainer(for: Goal.self, inMemory: true)
}
