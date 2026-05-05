//
//  TimelineEventViewViewModel.swift
//  Oncology-Dashboard-PP1
//
//  Created by Jonathan Dummett on 6/5/2026.
//

import Foundation

func getTestTimelineEvent(startDate: Date?, forceDate: Date? = nil) -> TimelineEvent {
    let randomEvent = EventID.allCases.randomElement()!
    
    
    var date = Date()
    if startDate != nil {
        date = Calendar.current.date(byAdding: .day, value: Int.random(in: 0...13), to: startDate!) ?? Date()
    }
    if forceDate != nil {
        date = forceDate!
    }
    
    switch randomEvent {
    case .chemotherapy:
        return TimelineEvent(
            eventId: .chemotherapy,
            date: date,
            notes: "Test Event"
        )
        
    case .appointment:
        return TimelineEvent(
            eventId: .appointment,
            date: date,
            notes: "Test Event"
        )
        
    case .emergency:
        return TimelineEvent(
            eventId: .emergency,
            date: date,
            notes: "Test Event"
        )
    case .other:
        return TimelineEvent(
            eventId: .other,
            date: date,
            notes: "Test Event",
            title: "Test Title"
        )
    }
}

