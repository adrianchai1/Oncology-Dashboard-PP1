//
//  PatientViewViewModel.swift
//  Oncology-Dashboard-PP1
//
//  Created by Adrian Chai on 27/4/2026.
//

import Foundation
import Observation

@MainActor
@Observable
class PatientsViewViewModel {
    var patients: [Patient] = []
    var errorMessage: String?

    func loadPatients() async {
        do {
            patients = try await fetchPatientsData()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
            print("Failed to fetch patients:", error)
        }
    }
}
