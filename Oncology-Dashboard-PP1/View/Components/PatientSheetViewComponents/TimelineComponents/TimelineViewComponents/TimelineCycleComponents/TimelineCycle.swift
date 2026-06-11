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
    let vm = TimelineCycleViewModel()

    var cycleEndDate: Date {
        Calendar.current.date(byAdding: .day, value: cycleLength, to: cycleStartDate) ?? Date()
    }
    
    var eventsInCycle: [TimelineEvent] {
        timelineEvents.filter { event in
            event.date >= cycleStartDate && event.date < cycleEndDate
        }
    }
    
    @State private var selectedEvent: TimelineEvent?
    
    
    
    
    var body: some View {
        VStack() {
            HStack() {
                Text("Cycle \(cycleNumber)")
                Spacer()
                Text("\(vm.formatDate(date: cycleStartDate)) - \(vm.formatDate(date: cycleEndDate))")
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
                    let groupedEvents = vm.groupEvents(timelineEvents: sortedEvents)
                    ForEach(groupedEvents.indices, id: \.self) { index in
                        let eventsList = groupedEvents[index]
                        // Stack for the timeline event and the line
                        if eventsList.count == 1 {
                            Button(action: {
                                selectedEvent = eventsList.first!
                            }) {
                                TimelineEventView(timelineEvent: eventsList.first!)
                                    .position(
                                        x: (geometry.size.width + 40) * vm.getXPosition(eventDate: eventsList.first!.date, cycleStartDate: cycleStartDate, cycleLength: cycleLength),
                                        y: geometry.size.height
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                        else {
                            TimelineEventMultipleView(timelineEvents: eventsList, selectedEvent: $selectedEvent)
                                .position(
                                    x: (geometry.size.width + 40) * vm.getXPosition(eventDate: eventsList.first!.date, cycleStartDate: cycleStartDate, cycleLength: cycleLength),
                                    y: geometry.size.height
                                )
                        }
                        
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

#Preview {
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
