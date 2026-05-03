//
//  EventSheetView.swift
//  Oncology-Dashboard-PP1
//
//  Created by Adrian Chai on 3/5/2026.
//

import SwiftUI

struct EventSheetView: View {
    let event: TimelineEvent
    @Environment(\.dismiss) private var dismiss
        
    var body: some View {
        NavigationStack {
            VStack {
                HStack() {
                    Text(event.date.formatted(date: .abbreviated, time: .shortened))
                    Spacer()
                }.padding(10)
                Spacer()
                
                if (event.eventId == EventID.chemotherapy) {
                    Text("Treatment Details")
                    List {
                        HStack {
                            Text("Regimen/Drug")
                            Spacer()
                            Text("IV Chemotherapy Drug")
                                .foregroundStyle(.secondary)
                        }
                        HStack {
                            Text("Dose")
                            Spacer()
                            Text("175mg")
                                .foregroundStyle(.secondary)
                        }
                        HStack {
                            Text("Route")
                            Spacer()
                            Text("IV")
                                .foregroundStyle(.secondary)
                        }
                        HStack {
                            Text("Duration")
                            Spacer()
                            Text("3 hrs")
                                .foregroundStyle(.secondary)
                        }
                        HStack {
                            Text("Location")
                            Spacer()
                            Text("Oncology Ward Floor 3")
                                .foregroundStyle(.secondary)
                        }
                    }.scrollContentBackground(.hidden)
                }
            }.navigationTitle(event.getTitle).navigationBarTitleDisplayMode(.inline).toolbar {
                ToolbarItem {
                    Button() {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }.buttonStyle(.borderedProminent).tint(Color(.nhBlue))
                }
            }
        }
    }
}

#Preview {
    EventSheetView(event: getTestTimelineEvent(startDate: Date()))
}

