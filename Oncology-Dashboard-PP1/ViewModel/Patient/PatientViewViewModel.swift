//
//  PatientViewViewModel.swift
//  Oncology-Dashboard-PP1
//
//  Created by Adrian Chai on 27/4/2026.
//

import Foundation
import Observation

@Observable
class PatientsViewViewModel {
    var patients: [Patient] = []

    func fetchPatients() {
        guard let url = URL(string: "http://170.64.254.24:3001/api/patients") else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Network error:", error)
                return
            }

            guard let data = data else {
                print("No data")
                return
            }
            do {
                let decodedDTOs = try JSONDecoder().decode([PatientDTO].self, from: data)
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let mappedPatients = decodedDTOs.map { dto in
                    Patient(
                        id: dto.id,
                        urn: dto.urn,
                        cancerType: dto.cancer_type,
                        patientName: dto.name,
                        treatmentStartDate: formatter.date(from: dto.treatment_start_date) ?? Date(),
                        cycleCount: dto.cycle_count,
                        cycleLengthInDays: dto.cycle_duration_days,
                        sleepPercentage: dto.sleep_percentage,
                        physiologicalPercentage: dto.physiological_percentage,
                        patientReportedPercentage: dto.patient_reported_percentage,
                        activityPercentage: dto.activity_percentage
                    )
                }
                DispatchQueue.main.async {
                    self.patients = mappedPatients
                    print("Loaded patients:", self.patients.count)
                }
            } catch {
                print("Decoding error:", error)
            }
        }.resume()
    }
}
