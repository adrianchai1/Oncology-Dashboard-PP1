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
    
    @Binding var displayPhysiological: Bool
    @Binding var displayActivity: Bool
    @Binding var displaySleep: Bool
    @Binding var displaySelfReported: Bool
    
    // Doing this so I can parse in the patient start date to validate new entries -Jonno
    init(
        timelineCycleCount: Int,
        patientStartDate: Date,
        cycleLengthInDays: Int,
        timelineEvents: [TimelineEvent],
        chemoEvents: [ChemotherapyEvent],
        selectedCycle: Binding<Int>,
        displayPhysiological: Binding<Bool>,
        displayActivity: Binding<Bool>,
        displaySleep: Binding<Bool>,
        displaySelfReported: Binding<Bool>
    ) {
        self.timelineCycleCount = timelineCycleCount
        self.patientStartDate = patientStartDate
        self.cycleLengthInDays = cycleLengthInDays
        self.timelineEvents = timelineEvents
        self.chemoEvents = chemoEvents
        self._selectedCycle = selectedCycle
        self._displayPhysiological = displayPhysiological
        self._displaySleep = displaySleep
        self._displayActivity = displayActivity
        self._displaySelfReported = displaySelfReported

        _vm = State(
            initialValue: TimelineViewViewModel(
                patientTreatmentStartDate: patientStartDate,
                patientTreatmentEndDate: Calendar.current.date(byAdding: .day, value: cycleLengthInDays * timelineCycleCount, to: patientStartDate) ?? Date()
            )
        )
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal) {
                ZStack(alignment: .bottomLeading) {
                    // All of the timeline Cycles
                    
                    LazyHStack {
                        ForEach(0..<timelineCycleCount, id: \.self) { i in
                            let cycleStart = Calendar.current.date(
                                byAdding: .day,
                                value: i * 14,
                                to: patientStartDate
                            )
                            TimelineCycle(cycleNumber: i + 1, cycleStartDate: cycleStart ?? Date(), cycleLength: cycleLengthInDays, isSelected: selectedCycle == i, timelineEvents: timelineEvents, chemoEvents: chemoEvents).contentShape(Rectangle()).onTapGesture {
                                selectedCycle = i
                                
                            }
                            
                            .id(i)
                        }
                    }
                    
                    LineGraph(patientPercentages: vm.patientPercentages, displayPhysiological: $displayPhysiological, displayActivity: $displayActivity, displaySleep: $displaySleep, displaySelfReported: $displaySelfReported)
                        .padding(.vertical, 50)
                        .padding(.horizontal, 20)
                        .allowsHitTesting(false)
                    //                 Timeline heatmap bar
                    //                    .padding(.top, 20)
                    //                TimelineBar()
                    //                    .padding(.horizontal, 10)
                    //                    .zIndex(1)
                }
            }
            .onAppear {
                DispatchQueue.main.async {
                    if timelineCycleCount > 0 {
                        proxy.scrollTo(timelineCycleCount - 1, anchor: .trailing)
                    }
                }
            }
        }
        .task {
            vm.fetchPatientPercentages(for: 1)
        }
    }
}
