//
//  PatientView.swift
//  Oncology-Dashboard-PP1
//
//  Created by Adrian Chai on 27/4/2026.
//

import SwiftUI

struct PatientView: View {
    // this should be pulled from the VM, will do during next refactor
    
    let cols = [GridItem(.adaptive(minimum: 400))]
    
    @State private var selection: String = "High"
    let priorities = ["High", "Medium", "Low"]
    var body: some View {
        ScrollView {
            LazyVGrid(columns: cols) {
                ForEach(0..<100) { i in
                    PatientCard(patientName: "Tina Dinh", cycleNumber: 4, URNumber: "1003456", sleepPercentage: 34, physiologicalPercentage: 55, activityPercentage: 73, patientReportedPercentage: 42)
                }
            }
        }.toolbar {
            ToolbarItem(placement: .principal) {
                Picker("Priority", selection: $selection) {
                    ForEach(priorities, id: \.self) {
                        Text($0)
                    }
                }.pickerStyle(.segmented).frame(width:450)
            }
        }
    }
}

#Preview {
    PatientView()
}
