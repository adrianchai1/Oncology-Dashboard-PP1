//
//  RingsCard.swift
//  Oncology-Dashboard-PP1
//
//  Created by Adrian Chai on 28/4/2026.
//

import SwiftUI

struct RingsCard: View {
    let sleepPercentage: Double
    let physiologicalPercentage: Double
    let activityPercentage: Double
    let patientReportedPercentage: Double
    var body: some View {
        HStack {
            RingStack(title: "Sleep", percentage: sleepPercentage, stackColour: .purple)
            RingStack(title: "Physiological", percentage: physiologicalPercentage, stackColour: .red)
            RingStack(title: "Activity", percentage: activityPercentage, stackColour: .teal)
            RingStack(title: "Patient Reported", percentage: patientReportedPercentage, stackColour: .orange)
        }.padding().background {
            RoundedRectangle(cornerRadius: 15).fill(.clear).background(.ultraThinMaterial)
        }
    }
}

#Preview {
    RingsCard(sleepPercentage: 30, physiologicalPercentage: 53, activityPercentage: 44, patientReportedPercentage: 40)
}
