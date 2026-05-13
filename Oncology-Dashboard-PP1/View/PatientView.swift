//
//  PatientView.swift
//  Oncology-Dashboard-PP1
//
//  Created by Adrian Chai on 27/4/2026.
//

import SwiftUI

struct PatientView: View {
    // this should be pulled from the VM, will do during next refactor
    
    let cols = [GridItem(.flexible(),spacing: 5), GridItem(.flexible(),spacing: 5)]
    
    @State private var vm = PatientsViewViewModel(patients: patientsDB)
    @State private var selection: String = "High"
    @State private var selectedPatient: Patient?
    
    let priorities = ["High", "Medium", "Low"]
    var body: some View {
        ScrollView {
            LazyVGrid(columns: cols) {
                ForEach(vm.patients) { patient in
                    PatientCard(patientName: patient.patientName, cycleNumber: patient.cycleCount, URNumber: patient.URN, sleepPercentage: patient.sleepPercentage, physiologicalPercentage: patient.physiologicalPercentage, activityPercentage: patient.activityPercentage, patientReportedPercentage: patient.patientReportedPercentage)
                        .onTapGesture {
                            selectedPatient = patient
                    }
                }
            }
        }.fullScreenCover(item: $selectedPatient) { selected in
            PatientSheetView(patient: selected)
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
