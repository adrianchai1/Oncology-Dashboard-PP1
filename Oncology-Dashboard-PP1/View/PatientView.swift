//
//  PatientView.swift
//  Oncology-Dashboard-PP1
//
//  Created by Adrian Chai on 27/4/2026.
//

import SwiftUI

struct PatientView: View {
    @State private var vm = PatientsViewViewModel()
    
    let cols = [GridItem(.flexible(),spacing: 5), GridItem(.flexible(),spacing: 5)]
    
    @State private var selection: String = "High"
    @State private var selectedPatient: Patient?
    
    let priorities = ["High", "Medium", "Low"]
    var body: some View {

        ScrollView {
            if vm.patients.isEmpty {
                Text("No patients loaded")
                Text(vm.patients.count.description)
                    .foregroundStyle(.secondary)
                    .padding()
            } else {
                LazyVGrid(columns: cols) {
                    ForEach(vm.patients) { patient in
                        PatientCard(
                            patientName: patient.patientName,
                            cycleNumber: patient.cycleCount,
                            URNumber: patient.urn,
                            patientId: patient.id,
                            latestCycleStartDate: Calendar.current.date(
                                byAdding: .day,
                                value: (patient.cycleCount * 14) - 13,
                                to: patient.treatmentStartDate
                            ) ?? Date()
                        )
                        .onTapGesture {
                            selectedPatient = patient
                        }
                    }
                }
                .padding()
            }
        }
        .task {
            await vm.loadPatients()
        }
        .fullScreenCover(item: $selectedPatient) { selected in
            PatientSheetView(patient: selected)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Picker("Priority", selection: $selection) {
                    ForEach(priorities, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 450)
            }
        }
    }
}

#Preview {
    PatientView()
}
