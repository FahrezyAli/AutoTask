//
//  ContentView.swift
//  AutoTask
//
//  Created by Ali Ahmad Fahrezy on 08/05/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            DiaryView().tabItem {
                Label("Chat", systemImage: "message")
            }
            ScheduleView().tabItem {
                Label("Schedule", systemImage: "calendar")
            }
            GoalsView().tabItem {
                Label("Goals", systemImage: "flag")
            }
        }
        .enableInjection()
    }

    #if DEBUG
        @ObserveInjection var forceRedraw
    #endif
}

#Preview {
    ContentView().modelContainer(for: Diary.self, inMemory: true)
        .modelContainer(for: Schedule.self, inMemory: true)
        .modelContainer(for: Goal.self, inMemory: true)
}
