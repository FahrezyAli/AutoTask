//
//  ScheduleView.swift
//  AutoTask
//
//  Created by Ali Ahmad Fahrezy on 18/06/25.
//

//
//  CalenderView.swift
//  AutoTask
//
//  Created by Ali Ahmad Fahrezy on 05/06/25.
//

import SwiftData
import SwiftUI

struct ScheduleView: View {
    @Query(sort: \Schedule.date) var items: [Schedule]
    var groupedItems: [Date: [Schedule]] {
        Dictionary(grouping: items) {
            Calendar.current.startOfDay(for: $0.date)
        }
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(groupedItems.keys.sorted(), id: \.self) { date in
                    Section(
                        header: Text(
                            date.formatted(date: .abbreviated, time: .omitted)
                        )
                    ) {
                        ForEach(groupedItems[date] ?? []) { item in
                            HStack {
                                Text(
                                    "\(item.activity), \(item.date.formatted(date: .omitted, time: .shortened))"
                                )
                                Spacer()
                                Toggle(
                                    "",
                                    isOn: Binding(
                                        get: { item.isCompleted },
                                        set: { item.isCompleted = $0 }
                                    )
                                )
                                .labelsHidden()
                            }
                        }
                    }
                }
            }
            .navigationTitle("Schedule")
        }
        .enableInjection()
    }

    #if DEBUG
        @ObserveInjection var forceRedraw
    #endif
}

#Preview {
    ScheduleView().modelContainer(for: Schedule.self, inMemory: true)
}
