//
//  TimelineEvent.swift
//  Oncology-Dashboard-PP1
//
//  Created by Jonathan Dummett on 29/4/2026.
//

import Foundation
import SwiftUI

enum EventID: Codable, CaseIterable {
    case chemotherapy
    case appointment
    case emergency
    case other
}

struct TimelineEvent: Identifiable, Codable {
    var id: UUID = UUID()
    var eventId: EventID
    var date: Date
    var notes: String
    var doctorId: UUID = UUID()
    var title: String?
    
    var getTitle: String {
       if title != nil {
            return title!
        }
        
        switch eventId {
        case .chemotherapy:
            return "Chemotherapy"
        case .appointment:
            return "Appointment"
        case .emergency:
            return "Emergency"
        case .other:
            return "Other"
        }
    }
    
    var getIcon: String {
        switch eventId {
        case .chemotherapy:
            return "pills"
        case .appointment:
            return "calendar"
        case .emergency:
            return "heart"
        case .other:
            return "questionmark"
        }
    }
    
    var getColor: Color {
        switch eventId {
        case .chemotherapy:
            return .green.opacity(0.5)
        case .appointment:
            return .blue.opacity(0.5)
        case .emergency:
            return .red.opacity(0.5)
        case .other:
            return .gray.opacity(0.5)
        }
    }
}

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

