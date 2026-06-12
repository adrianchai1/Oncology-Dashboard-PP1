//
//  NewTimelineEventViewViewModel.swift
//  Oncology-Dashboard-PP1
//
//  Created by Jonathan Dummett on 12/6/2026.
//

import Foundation
import Observation

@Observable
class NewTimelineEventViewViewModel {
    func validateForm(selectedEventType: String, title: String, selectedDate: Date) -> String {
        
        if selectedEventType == EventID.other.title && title == "" {
            return "Error: Missing event title"
        }
        
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        let startOfInput = calendar.startOfDay(for: selectedDate)
    
        if startOfInput > startOfToday {
            return "Error: Event date cannot be in the future"
        }
        
        return ""
    }
}
