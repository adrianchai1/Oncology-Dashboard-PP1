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
                .frame(width: 30, height: 30)
                .foregroundColor(timelineEvent.getColor)
            
            Image(systemName: "\(timelineEvent.getIcon)")
                .font(.system(size: 15, weight: .bold))
        }
    }
}

#Preview {
    TimelineEventView(timelineEvent: getTestTimelineEvent(startDate: Date(), forceDate: Date()))
    TimelineEventView(timelineEvent: getTestTimelineEvent(startDate: Date()))
    TimelineEventView(timelineEvent: getTestTimelineEvent(startDate: Date()))
    TimelineEventView(timelineEvent: getTestTimelineEvent(startDate: Date()))
    TimelineEventView(timelineEvent: getTestTimelineEvent(startDate: Date()))
    TimelineEventView(timelineEvent: getTestTimelineEvent(startDate: Date()))
    TimelineEventView(timelineEvent: getTestTimelineEvent(startDate: Date()))
    TimelineEventView(timelineEvent: getTestTimelineEvent(startDate: Date()))
    TimelineEventView(timelineEvent: getTestTimelineEvent(startDate: Date()))
}
