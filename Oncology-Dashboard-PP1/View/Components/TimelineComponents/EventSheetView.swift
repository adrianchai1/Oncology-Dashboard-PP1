//
//  EventSheetView.swift
//  Oncology-Dashboard-PP1
//
//  Created by Adrian Chai on 3/5/2026.
//

import SwiftUI

struct EventSheetView: View {
    let event: TimelineEvent
    let chemoEvents: [ChemotherapyEvent]
    @Environment(\.dismiss) private var dismiss
    
    var details: ChemotherapyEvent? {
        chemoEvents.first { chemo in
            chemo.timelineEventId == event.id
        }
    }
        
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
                    ChemotherapyDescriptionView(details: details, clinicalNotes: event.notes)
                case EventID.appointment:
                    AppointmentDescriptionView(clinicalNotes: event.notes)
                case EventID.emergency:
                    EmergencyDescriptionView(clinicalNotes: event.notes)
                case EventID.other:
                    OtherDescriptionView(title: event.title ?? "")
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

