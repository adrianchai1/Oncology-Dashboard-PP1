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
    @State private var selectedCycle = -1
    
    @State var showNewEventForm = false
    
    @State var displayPhysiological: Bool = true
    @State var displayActivity: Bool = true
    @State var displaySleep: Bool = true
    @State var displaySelfReported: Bool = true
    
    var body: some View {
        
        ZStack {
            NavigationStack {
                ScrollView(.vertical) {
                    HStack(alignment: .top, spacing: 10) {
                        RadarGraphView()
                            .frame(maxWidth: .infinity)
                            .frame(height: 450)
                        SideCardView(patientId: patient.id)
                            .frame(maxWidth: .infinity)
                            .frame(height: 450)
                    }
                    
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
            }
            if selectedCycle != -1 {
                ZStack {
                    
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.spring()) {
                                selectedCycle = -1
                            }
                        }
                    VStack {
                        Spacer()
                        //                    Text(cycle: cycle)
                        CycleBreakdownView(patientId: patient.id, treatmentStartDate: patient.treatmentStartDate, cycleLength: patient.cycleLengthInDays, selectedCycle: $selectedCycle)
                            .frame(maxWidth: .infinity)
                            .frame(height: UIScreen.main.bounds.height * 0.7)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(radius: 20)
                    }
                    .ignoresSafeArea()
                    .transition(.move(edge: .bottom))
                }
                .animation(.spring(), value: selectedCycle != -1)
            }
        }.task {
            vm.fetchEvents(for: patient.id)
            chemoVM.fetchChemotherapyEvents(for: patient.id)
        }.sheet(isPresented: $showNewEventForm) {
            NewTimelineEventView()
        }
    }
}

