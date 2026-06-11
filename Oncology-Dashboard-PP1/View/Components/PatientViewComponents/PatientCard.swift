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
    let patientId: Int
    
    var vm = PatientCardViewViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text(patientName).font(.title).fontWeight(.bold)
                    Text("Cycle \(cycleNumber)").font(.title2).fontWeight(.semibold).foregroundStyle(Color(.nhBlue))
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("UR Number:")
                    Text(URNumber)
                }
            }.padding()
            RingsCard(sleepPercentage: vm.sleepPercentage, physiologicalPercentage: vm.physiologicalPercentage, activityPercentage: vm.activityPercentage, patientReportedPercentage: vm.moodPercentage)
        }.padding().frame(minHeight: 200).frame(maxWidth: .infinity).background() {
            RoundedRectangle(cornerRadius: 12).fill(.clear).glassEffect(in: .rect(cornerRadius: 12))
        }.clipShape(RoundedRectangle(cornerRadius: 12)).padding()
            .task {
                await vm.loadPercentages(patientId: patientId)
            }
    }
    
}

#Preview {
    PatientCard(patientName: "Tina Dinh", cycleNumber: 4, URNumber: "1003456", patientId: 1)
}
