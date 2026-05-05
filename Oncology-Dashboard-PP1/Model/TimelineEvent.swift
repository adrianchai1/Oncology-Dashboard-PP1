//
//  TimelineEvent.swift
//  Oncology-Dashboard-PP1
//
//  Created by Jonathan Dummett on 6/5/2026.
//

import Foundation

struct TimelineEvent: Identifiable, Codable {
    var id: UUID = UUID()
    var eventId: EventID
    var date: Date
    var notes: String
    var doctorId: UUID = UUID()
    var title: String?
    
    
    var displayTitle: String {
        title ?? eventId.title
    }
}
