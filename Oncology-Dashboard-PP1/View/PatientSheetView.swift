//
//  PatientSheetView.swift
//  Oncology-Dashboard-PP1
//
//  Created by Adrian Chai on 30/4/2026.
//

import SwiftUI

struct PatientSheetView: View {
    
    let patient: Patient
    
    @Environment(\.dismiss) private var dismiss
    @State private var selectedCycle = 0
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack {
                    HStack {
                        Spacer()
                        TimelineLegend()
                    }
                    .padding(EdgeInsets(top: 30, leading: 10, bottom: 0, trailing: 10))
                    TimelineView(timelineCycleCount: patient.cycleCount, patientStartDate: patient.treatmentStartDate, selectedCycle: $selectedCycle).padding(EdgeInsets(top: 0, leading: 10, bottom: 20, trailing: 10))
                    Text("Significant Deviations from Baseline").font(Font.title.bold())
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
    }
}

#Preview {
    PatientSheetView(patient: TinaDinh)
}
