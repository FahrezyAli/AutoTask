//
//  CalenderView.swift
//  AutoTask
//
//  Created by Ali Ahmad Fahrezy on 05/06/25.
//

import SwiftData
import SwiftUI

struct CalenderView: View {
    @Query private var schedules: [Schedule]

    var body: some View {
        NavigationView {
            List {
                ForEach(schedules) { item in
                    VStack(alignment: .leading) {
                        Text(item.activity)
                            .font(.headline)
                        Text(
                            item.time.formatted(
                                date: .omitted,
                                time: .shortened
                            )
                        )
                        .font(.subheadline)
                    }
                }
            }
            .navigationTitle("Calendar")
        }
        .enableInjection()
    }

    #if DEBUG
        @ObserveInjection var forceRedraw
    #endif
}

#Preview {
    CalenderView().modelContainer(for: Schedule.self, inMemory: true)
}
