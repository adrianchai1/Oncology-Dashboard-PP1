//
//  TimelineView.swift
//  Oncology-Dashboard-PP1
//
//  Created by Jonathan Dummett on 29/4/2026.
//

import SwiftUI

struct TimelineView: View {
    
    
    let timelineCycleCount: Int
    let patientStartDate: Date
    let cycleLengthInDays: Int
    let timelineEvents: [TimelineEvent]
    let chemoEvents: [ChemotherapyEvent]
    @Binding var selectedCycle: Int
    
    @State private var vm: TimelineViewViewModel
    
    // Doing this so I can parse in the patient start date to validate new entries -Jonno
    init(
        timelineCycleCount: Int,
        patientStartDate: Date,
        cycleLengthInDays: Int,
        timelineEvents: [TimelineEvent],
        chemoEvents: [ChemotherapyEvent],
        selectedCycle: Binding<Int>
    ) {
        self.timelineCycleCount = timelineCycleCount
        self.patientStartDate = patientStartDate
        self.cycleLengthInDays = cycleLengthInDays
        self.timelineEvents = timelineEvents
        self.chemoEvents = chemoEvents
        self._selectedCycle = selectedCycle

        _vm = State(
            initialValue: TimelineViewViewModel(
                patientTreatmentStartDate: patientStartDate,
                patientTreatmentEndDate: Calendar.current.date(byAdding: .day, value: cycleLengthInDays * timelineCycleCount, to: patientStartDate) ?? Date()
            )
        )
    }
    
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
                        TimelineCycle(cycleNumber: i + 1, cycleStartDate: cycleStart ?? Date(), cycleLength: cycleLengthInDays, isSelected: selectedCycle == i, timelineEvents: timelineEvents, chemoEvents: chemoEvents).contentShape(Rectangle()).onTapGesture {
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
