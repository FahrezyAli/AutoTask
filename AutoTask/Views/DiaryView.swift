//
//  DiaryView.swift
//  AutoTask
//
//  Created by Ali Ahmad Fahrezy on 04/06/25.
//

import SwiftData
import SwiftUI

struct DiaryView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Diary.timestamp) private var messages: [Diary]
    @State private var inputText: String = ""

    var body: some View {
        NavigationView {
            VStack {
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(messages) { message in
                                HStack {
                                    Text(message.content)
                                        .padding(10)
                                        .background(Color.blue.opacity(0.2))
                                        .cornerRadius(10)
                                    Spacer()
                                }
                                .id(message.id)
                            }
                        }
                        .padding()
                    }
                    .onChange(of: messages.count) { _ in
                        if let last = messages.last {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }

                HStack {
                    TextField("Type a message...", text: $inputText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button(
                        action: {
                            guard
                                !inputText.trimmingCharacters(in: .whitespaces)
                                    .isEmpty
                            else { return }

                            let newMessage = Diary(content: inputText)
                            context.insert(newMessage)

                            let parsed = DiaryParser.extractDetails(
                                from: inputText
                            )

                            if let activity = parsed.activity {
                                let schedule = Schedule(
                                    activity: activity,
                                    date: parsed.date,
                                    goal: parsed.goal
                                )
                                context.insert(schedule)
                            }

                            if let goalName = parsed.goal {
                                let goal = Goal(name: goalName)
                                goal.messages.append(newMessage)
                                newMessage.goal = goal
                                context.insert(goal)
                            }

                            print("Parsed Date: \(parsed.date.formatted())")
                            print(
                                "Parsed Activity: \(parsed.activity ?? "nil")"
                            )
                            print("Parsed Goal: \(parsed.goal ?? "nil")")

                            inputText = ""
                        },
                        label: {
                            Text("Send")
                        }
                    )
                }
                .padding()
            }
            .navigationTitle("Diary")
        }
        .enableInjection()
    }

    #if DEBUG
        @ObserveInjection var forceRedraw
    #endif
}

#Preview {
    DiaryView()
        .modelContainer(for: Diary.self, inMemory: true)
}
