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
        HStack(alignment: .top, spacing: 16) {
            RingStack(title: "Sleep", percentage: sleepPercentage, stackColour: .sleep)
            RingStack(title: "Physiological", percentage: physiologicalPercentage, stackColour: .physiological)
            RingStack(title: "Activity", percentage: activityPercentage, stackColour: .activity)
            RingStack(title: "Patient\nReported", percentage: patientReportedPercentage, stackColour: .selfReported)
        }.padding().frame(maxWidth: .infinity).background() {
            RoundedRectangle(cornerRadius: 12).fill(.ultraThinMaterial)
        }.clipShape(RoundedRectangle(cornerRadius: 12)).padding()
    }
}

#Preview {
    RingsCard(sleepPercentage: 30, physiologicalPercentage: 53, activityPercentage: 44, patientReportedPercentage: 40)
}
