//
//  TimelineCycleViewModel.swift
//  Oncology-Dashboard-PP1
//
//  Created by Jonathan Dummett on 11/6/2026.
//

import Foundation
import Observation

@Observable
class TimelineCycleViewModel {
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
    
    func groupEvents(timelineEvents: [TimelineEvent]) -> [[TimelineEvent]] {
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
    
    
    func getXPosition(eventDate: Date, cycleStartDate: Date, cycleLength: Int) -> CGFloat {
        let components = Calendar.current.dateComponents([.day], from: cycleStartDate, to: eventDate)
        let dayDifference = components.day ?? 0
        
        return CGFloat(dayDifference) / CGFloat(cycleLength)
    }
}
