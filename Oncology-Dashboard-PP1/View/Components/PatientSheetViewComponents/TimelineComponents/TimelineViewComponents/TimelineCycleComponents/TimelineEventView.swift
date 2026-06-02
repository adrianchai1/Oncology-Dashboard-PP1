//
//  TimelineEventView.swift
//  Oncology-Dashboard-PP1
//
//  Created by Jonathan Dummett on 29/4/2026.
//

import SwiftUI

struct TimelineEventView: View {
    var timelineEvent: TimelineEvent
    
    var body: some View {
        ZStack {
            Circle()
            // The commented out code is the white backgroound and colored image
            
                .frame(width: 35, height: 35)
                .foregroundColor(timelineEvent.eventId.color)
//                .foregroundStyle(Color(white: 1))
            
            Image(systemName: "\(timelineEvent.eventId.icon)")
                .font(.system(size: 15, weight: .bold))
//                .foregroundColor(timelineEvent.eventId.color)
        
        }
    }
}


#Preview {
    TimelineEventView(timelineEvent: TimelineEvent(id: 1, eventId: EventID.chemotherapy, date: Date(), notes: "Test", doctorId: 1))
}
