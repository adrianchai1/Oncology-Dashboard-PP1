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
    
    
    private func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
    
    private func groupEvents(timelineEvents: [TimelineEvent]) -> [[TimelineEvent]] {
        var groupedEvents: [[TimelineEvent]] = []
        var eventsAlreadyGrouped: [Int] = []
        
        for event in timelineEvents {
            if eventsAlreadyGrouped.contains(event.id) { continue }
            print(eventsAlreadyGrouped.contains(event.id))
            
            var group: [TimelineEvent] = [event]
            eventsAlreadyGrouped.append(event.id)
            
            let currentDay = event.date
            let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: currentDay) ?? Date()
            let eventsOnSameDay = timelineEvents.filter {
                $0.id != event.id &&
                (Calendar.current.isDate($0.date, inSameDayAs: currentDay) || Calendar.current.isDate($0.date, inSameDayAs: nextDay))
            }
            group.append(contentsOf: eventsOnSameDay)
            eventsAlreadyGrouped.append(contentsOf: eventsOnSameDay.map { $0.id })
            
            groupedEvents.append(group)
        }
        
        return groupedEvents
    }
    
    
    private func getXPosition(eventDate: Date) -> CGFloat {
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
                    Rectangle()
                        .frame(width: geometry.size.width + 40, height: 40)
                        .cornerRadius(10)
                        .foregroundStyle(
                            isSelected ? Color(red: (180.0 / 255.0), green: (215.0 / 255.0), blue: (222.0 / 255.0))
                            : Color(red: (200.0 / 255.0), green: (239.0 / 255.0), blue: (247.0 / 255.0)))
                        .position(
                            x: geometry.size.width / 2,
                            y: geometry.size.height
                        )
                    
                    
                    let sortedEvents = eventsInCycle.sorted { $0.date < $1.date }
                    let groupedEvents = groupEvents(timelineEvents: sortedEvents)
                    ForEach(groupedEvents.indices, id: \.self) { index in
                        let eventsList = groupedEvents[index]
                        // Stack for the timeline event and the line
                        if eventsList.count == 1 {
                            Button(action: {
                                selectedEvent = eventsList.first!
                            }) {
                                TimelineEventView(timelineEvent: eventsList.first!)
                                    .position(
                                        x: (geometry.size.width + 40) * getXPosition(eventDate: eventsList.first!.date),
                                        y: geometry.size.height
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                        else {
                            TimelineEventMultipleView(timelineEvents: eventsList, selectedEvent: $selectedEvent)
                                .position(
                                    x: (geometry.size.width + 40) * getXPosition(eventDate: eventsList.first!.date),
                                    y: geometry.size.height
                                )
                        }
                        
                    }
//                    ForEach(sortedEvents.indices, id: \.self) { index in
//                        let event = sortedEvents[index]
//                        // Stack for the timeline event and the line
//                        Button {
//                            selectedEvent = event
//                        } label: {
//                            VStack {
//                                // If the event is above the timeline, order the event before the rectangle
//                                TimelineEventView(timelineEvent: event)
//                                
//                                    .zIndex(3)
//                            }
//                        }.buttonStyle(.plain)
//                        .position(
//                            x: (geometry.size.width + 40) * getXPosition(eventDate: event.date),
//                            y: geometry.size.height
//                        )
//                    }
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

#Preview {
//    let timelineEvents: [TimelineEvent] = (0...13).map { dayOffset in
//            TimelineEvent(
//                id: dayOffset + 1,
//                eventId: EventID.chemotherapy,
//                date: Calendar.current.date(
//                    byAdding: .day,
//                    value: dayOffset,
//                    to: Date()
//                ) ?? Date(),
//                notes: "",
//                doctorId: 1
//            )
//        }
    let timelineEvents: [TimelineEvent] = [
        TimelineEvent(
            id: 1,
            eventId: EventID.chemotherapy,
            date: Calendar.current.date(
                byAdding: .day,
                value: 1,
                to: Date()) ?? Date(),
            notes: "",
            doctorId: 1
        ),
        TimelineEvent(
            id: 2,
            eventId: EventID.appointment,
            date: Calendar.current.date(
                byAdding: .day,
                value: 1,
                to: Date()) ?? Date(),
            notes: "",
            doctorId: 1
        ),
        
        TimelineEvent(
            id: 3,
            eventId: EventID.appointment,
            date: Calendar.current.date(
                byAdding: .day,
                value: 2,
                to: Date()) ?? Date(),
            notes: "",
            doctorId: 1
        ),
        
        TimelineEvent(
            id: 4,
            eventId: EventID.appointment,
            date: Calendar.current.date(
                byAdding: .day,
                value: 5,
                to: Date()) ?? Date(),
            notes: "",
            doctorId: 1
        )
    ]
    
    TimelineCycle(cycleNumber: 1, cycleStartDate: Date(), cycleLength: 14, isSelected: true, timelineEvents: timelineEvents, chemoEvents: [ChemotherapyEvent(id: 1, timelineEventId: 1, drugType: "", dosage: "", route: "", durationHours: 1, location: "")])
}
