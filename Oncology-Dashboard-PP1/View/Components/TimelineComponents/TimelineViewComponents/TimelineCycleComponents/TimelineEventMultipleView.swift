//
//  TimelineEventMultipleView.swift
//  Oncology-Dashboard-PP1
//
//  Created by Jonathan Dummett on 27/5/2026.
//

import SwiftUI

struct TimelineEventMultipleView: View {

    var timelineEvents: [TimelineEvent]
    @State var expanded = false

    var body: some View {
        ZStack {
            
            // dropdown arrow button anchored to its position
            Button(action: {
                expanded.toggle()
            }) {
                ZStack {
                    Circle()
                        .frame(width: 35, height: 35)
                        .foregroundColor(Color(white: 0.95))

                    Image(systemName: expanded ? "chevron.down" : "chevron.up")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(Color(white: 0.75))
                }
            }
        }
        .overlay(alignment: .bottom) {
            if expanded {
                VStack(spacing: 8) {
                    ForEach(timelineEvents, id: \.self) { event in
                        TimelineEventView(timelineEvent: event)
                    }
                }
                .padding(.bottom, 45)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }
}

#Preview {
    TimelineEventMultipleView(timelineEvents: [
        TimelineEvent(id: 1, eventId: EventID.chemotherapy, date: Date(), notes: "", doctorId: 1),
        TimelineEvent(id: 2, eventId: EventID.appointment, date: Date(), notes: "", doctorId: 1)
    ])
}
