//
//  TimelineEvent.swift
//  Oncology-Dashboard-PP1
//
//  Created by Jonathan Dummett on 6/5/2026.
//

import Foundation

struct TimelineEvent: Identifiable, Codable, Hashable {
    var id: Int
    var eventId: EventID
    var date: Date
    var notes: String
    var doctorId: Int
    var title: String?
    
    var displayTitle: String {
        title ?? eventId.title
    }
}
