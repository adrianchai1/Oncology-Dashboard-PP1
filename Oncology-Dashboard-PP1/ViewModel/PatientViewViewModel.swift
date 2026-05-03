//
//  PatientViewViewModel.swift
//  Oncology-Dashboard-PP1
//
//  Created by Adrian Chai on 27/4/2026.
//

import Foundation

@Observable
class PatientsViewViewModel {
    var patients: [Patient]
    
    init(patients: [Patient]) {
        self.patients = patients
    }
}
