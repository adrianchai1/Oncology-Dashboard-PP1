//
//  PatientSheetView.swift
//  Oncology-Dashboard-PP1
//
//  Created by Adrian Chai on 30/4/2026.
//

import SwiftUI

struct PatientSheetView: View {
    
    @State private var vm = PatientSheetViewViewModel()
    @State private var chemoVM = ChemotherapyEventsViewModel()
    
    let patient: Patient
    
    @Environment(\.dismiss) private var dismiss
    @State private var selectedCycle = 0
    
    @State var showNewEventForm = false
    
    @State var displayPhysiological: Bool = true
    @State var displayActivity: Bool = true
    @State var displaySleep: Bool = true
    @State var displaySelfReported: Bool = true
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack {
                    HStack {
                        TimelineLegendView(physiological: $displayPhysiological, activity: $displayActivity, sleep: $displaySleep, selfReported: $displaySelfReported)
                        Spacer()
                        TimelineEventLegendView()
                        
                        Button(action: {
                            showNewEventForm = true
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 40))
                                .foregroundStyle(.green)
                        }
                    }
                    .padding(EdgeInsets(top: 30, leading: 10, bottom: 0, trailing: 10))
                    TimelineView(
                        timelineCycleCount: patient.cycleCount,
                        patientStartDate: patient.treatmentStartDate,
                        cycleLengthInDays: patient.cycleLengthInDays,
                        timelineEvents: vm.timelineEvents,
                        chemoEvents: chemoVM.chemotherapyEvents,
                        selectedCycle: $selectedCycle,
                        displayPhysiological: $displayPhysiological,
                        displayActivity: $displayActivity,
                        displaySleep: $displaySleep,
                        displaySelfReported: $displaySelfReported
                    )
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 20, trailing: 10))
                    Text("Significant Deviations from Baseline").font(Font.title.bold())
                    
                    HStack {
                        GraphView(
                            xLabel: "Date",
                            yLabel: "Test",
                            graphData: getTestGraphData(),
                            color: Color.red
                        )
                        .frame(width: 400, height: 200)
                        .padding(.horizontal, 30)
                        
                        
                            GraphView(
                                xLabel: "Date",
                                yLabel: "Test",
                                graphData: getTestGraphData(),
                                color: Color.blue
                            )
                            .frame(width: 400, height: 200)
                            .padding(.horizontal, 30)
                    }
                    
                }.navigationTitle(patient.patientName).navigationBarTitleDisplayMode(.inline).toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button() {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                        }.buttonStyle(.borderedProminent).tint(Color(.nhBlue))
                    }
                }
            }
        }.task {
            vm.fetchEvents(for: patient.id)
            chemoVM.fetchChemotherapyEvents(for: patient.id)
        }.sheet(isPresented: $showNewEventForm) {
            NewTimelineEventView()
        }
    }
}

