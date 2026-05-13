//
//  NewTimelineEventView.swift
//  Oncology-Dashboard-PP1
//
//  Created by Vivi Nguyen on 1/5/2026.
//

import SwiftUI

struct NewTimelineEventView: View {
    @Environment(\.dismiss) private var dismiss
    
    var eventTypes: [String] = EventID.allCases.map(\.title)
    @State var selectedEventType = EventID.chemotherapy.title
    
    @State var title: String = ""
    @State var selectedDate = Date()
    @State var notes = ""
    
    @State var errorMessage: String = ""
    
    private func validateForm() {
        
        
        if selectedEventType == EventID.other.title && title == "" {
            errorMessage = "Error: Missing event title"
        }
        
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        let startOfInput = calendar.startOfDay(for: selectedDate)
        
        // Make sure the selected date is NOT in the future
        if startOfInput > startOfToday {
            errorMessage = "Error: Event date cannot be in the future"
        }
        
    }
    
    var body: some View {
        
        //        Text("")
        NavigationStack {
            Form {
                Picker("Event Type", selection: $selectedEventType) {
                    ForEach(eventTypes, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.menu)
                
                if selectedEventType == EventID.other.title {
                    HStack {
                        Text("Event Title")
                        
                        TextField("Event Title", text: $title)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                //            var id: UUID = UUID()
                //            var eventId: EventID
                //            var date: Date
                //            var notes: String
                //            var doctorId: UUID = UUID()
                //            var title: String?
                
                DatePicker("Select Date",
                           selection: $selectedDate,
                           displayedComponents: .date)
                
                
                Section("Notes") {
                    TextField("Notes", text: $notes)
                }
                
                
            }.navigationTitle("New Timeline Event").navigationBarTitleDisplayMode(.inline).toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button() {
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                    }.buttonStyle(.borderedProminent).tint(Color(.nhBlue))
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button() {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .buttonStyle(.borderedProminent).tint(Color(.red))
                }
            }
        }
    }
}

#Preview {
    NewTimelineEventView()
}
