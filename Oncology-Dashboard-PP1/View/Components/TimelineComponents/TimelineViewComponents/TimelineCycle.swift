//
//  TimelineCycle.swift
//  Oncology-Dashboard-PP1
//
//  Created by Jonathan Dummett on 29/4/2026.
//

import SwiftUI

struct TimelineCycle: View {
    
    let cycleNumber: Int
    let cycleStartDate: Date
    let cycleLength: Int
    let isSelected: Bool
    let timelineEvents: [TimelineEvent]
    let chemoEvents: [ChemotherapyEvent]

    var cycleEndDate: Date {
        Calendar.current.date(byAdding: .day, value: cycleLength, to: cycleStartDate) ?? Date()
    }
    
    var eventsInCycle: [TimelineEvent] {
        timelineEvents.filter { event in
            event.date >= cycleStartDate && event.date < cycleEndDate
        }
    }
    
    @State private var selectedEvent: TimelineEvent?
    
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
    
    
    
    func getXPosition(eventDate: Date) -> CGFloat {
        let components = Calendar.current.dateComponents([.day], from: cycleStartDate, to: eventDate)
        let dayDifference = components.day ?? 0
        
        return CGFloat(dayDifference) / CGFloat(cycleLength)
    }
    
    var body: some View {
        VStack() {
            HStack() {
                Text("Cycle \(cycleNumber)")
                Spacer()
                Text("\(formatDate(date: cycleStartDate)) - \(formatDate(date: cycleEndDate))")
                    .foregroundStyle(Color.gray)
                    .font(.system(size: 15, weight: .light, design: .default))
            }
            
            // Timeline Events layed out based on how far along in the week it is
            GeometryReader { geometry in
                ZStack {
                    let sortedEvents = eventsInCycle.sorted { $0.date < $1.date }
                    ForEach(sortedEvents.indices, id: \.self) { index in
                        let event = sortedEvents[index]
                        let yValue = CGFloat((index % 2 == 0) ? 3 : 1)
                        // Stack for the timeline event and the line
                        Button {
                            selectedEvent = event
                        } label: {
                            VStack {
                                // If the event is above the timeline, order the event before the rectangle
                                if yValue == 1 {
                                    TimelineEventView(timelineEvent: event)
                                }
                                Rectangle()
                                    .fill(event.eventId.color)
                                    .frame(width: 2, height: 50)
                                
                                // Otherwise order the rectangle before the event.
                                if yValue != 1 {
                                    TimelineEventView(timelineEvent: event)
                                }
                            }
                        }.buttonStyle(.plain)
                        .position(
                            x: geometry.size.width * getXPosition(eventDate: event.date),
                            y: (yValue == 1)
                            ? geometry.size.height * 0.20
                            : geometry.size.height * 0.80
                        )
                    }
                }
            }
            .padding(.horizontal, 5)
            Spacer()
        }
        .padding(20)
        .frame(width: 300, height: 300)
        .background(isSelected ? Color(white: 0.85) : Color(white: 0.95))
        .cornerRadius(20).sheet(item: $selectedEvent) { event in
            EventSheetView(event: event, chemoEvents: chemoEvents)
        }
    }
}

