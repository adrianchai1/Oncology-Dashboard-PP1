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
                
                switch event.eventId {
                case EventID.chemotherapy:
                    ChemotherapyDescription()
                case EventID.appointment:
                    AppointmentDescription()
                case EventID.emergency:
                    EmergencyDescription()
                case EventID.other:
                    OtherDescription(title: event.title ?? "")
                }
            }.navigationTitle(event.eventId.title).navigationBarTitleDisplayMode(.inline).toolbar {
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

