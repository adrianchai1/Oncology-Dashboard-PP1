//
//  TimelineView.swift
//  Oncology-Dashboard-PP1
//
//  Created by Jonathan Dummett on 29/4/2026.
//

import SwiftUI

struct TimelineView: View {
    
    @State private var vm = TimelineViewViewModel()
    
    let timelineCycleCount: Int
    let patientStartDate: Date
    let timelineEvents: [TimelineEvent]
    let chemoEvents: [ChemotherapyEvent]
    @Binding var selectedCycle: Int
    
    
    
    var body: some View {
        ScrollView(.horizontal) {
            ZStack(alignment: .leading) {
                // All of the timeline Cycles
                LazyHStack {
                    ForEach(0..<timelineCycleCount) { i in
                        let cycleStart = Calendar.current.date(
                            byAdding: .day,
                            value: i * 14,
                            to: patientStartDate
                        )
                        TimelineCycle(cycleNumber: i + 1, cycleStartDate: cycleStart ?? Date(), cycleLength: 14, isSelected: selectedCycle == i, timelineEvents: timelineEvents, chemoEvents: chemoEvents).contentShape(Rectangle()).onTapGesture {
                                selectedCycle = i
                        }
                    }
                }
                
                LineGraph(patientPercentages: vm.patientPercentages)
                    .padding(.vertical, 50)
                    .padding(.horizontal, 20)
                // Timeline heatmap bar
//                TimelineBar()
//                    .padding(.horizontal, 10)
//                    .padding(.top, 20)
            }
        }
        .task {
            vm.fetchPatientPercentages(for: 1)
        }
    }
}
