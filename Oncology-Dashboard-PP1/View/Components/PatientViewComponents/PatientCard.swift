//
//  PatientCard.swift
//  Oncology-Dashboard-PP1
//
//  Created by Adrian Chai on 27/4/2026.
//

import SwiftUI

struct PatientCard: View {
    let patientName: String
    let cycleNumber: Int
    let URNumber: String
    let sleepPercentage: Double
    let physiologicalPercentage: Double
    let activityPercentage: Double
    let patientReportedPercentage: Double
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text(patientName).font(.title).fontWeight(.bold)
                    Text("Cycle \(cycleNumber)").font(.title2).fontWeight(.semibold).foregroundStyle(Color(.red))
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("UR Number:")
                    Text(URNumber)
                }
            }.padding()
            RingsCard(sleepPercentage: sleepPercentage, physiologicalPercentage: physiologicalPercentage, activityPercentage: activityPercentage, patientReportedPercentage: patientReportedPercentage)
        }.padding().frame(minHeight: 200).frame(maxWidth: .infinity).background() {
            RoundedRectangle(cornerRadius: 12).fill(.clear).glassEffect(in: .rect(cornerRadius: 12))
        }.clipShape(RoundedRectangle(cornerRadius: 12)).padding()
    }
}

#Preview {
    PatientCard(patientName: "Tina Dinh", cycleNumber: 4, URNumber: "1003456", sleepPercentage: 34, physiologicalPercentage: 55, activityPercentage: 73, patientReportedPercentage: 42)
}
