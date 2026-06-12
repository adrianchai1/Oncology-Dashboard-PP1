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
    
    var vm = NewTimelineEventViewViewModel()
    
    var body: some View {
        
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
                
                DatePicker("Select Date",
                           selection: $selectedDate,
                           displayedComponents: .date)
                
                
                Section("Notes") {
                    TextField("Notes", text: $notes)
                }
                
                
                if errorMessage != "" {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }
                
            }.navigationTitle("New Timeline Event").navigationBarTitleDisplayMode(.inline).toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button() {
                        let validForm = vm.validateForm(selectedEventType: selectedEventType, title: title, selectedDate: selectedDate)
                        errorMessage = validForm
                        if validForm == "" {
                            // TODO: SAVE TO DB
                            
                            dismiss()
                        }
                        
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
