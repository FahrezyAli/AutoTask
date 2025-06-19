//
//  GoalsView.swift
//  AutoTask
//
//  Created by Ali Ahmad Fahrezy on 05/06/25.
//

import SwiftData
import SwiftUI

struct GoalsView: View {
    @Query var schedule: [Schedule]

    var goalGroups: [String: [Schedule]] {
        Dictionary(grouping: schedule.filter { $0.goal != nil }) {
            $0.goal ?? ""
        }
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(goalGroups.keys.sorted(), id: \.self) { goal in
                    VStack(alignment: .leading) {
                        Text(goal)
                            .font(.headline)

                        let items = goalGroups[goal]!
                        let progress =
                            Double(items.filter { $0.isCompleted }.count)
                            / Double(items.count)

                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .frame(height: 6)
                                    .foregroundColor(.gray.opacity(0.2))
                                Rectangle()
                                    .frame(
                                        width: geo.size.width * progress,
                                        height: 6
                                    )
                                    .foregroundColor(.green)
                                    .animation(.easeInOut, value: progress)
                            }
                            .cornerRadius(3)
                        }
                        .frame(height: 6)
                    }
                    .padding(.vertical, 8)
                }
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
