//
//  PatientDTO.swift
//  Oncology-Dashboard-PP1
//
//  Created by Adrian Chai on 9/6/2026.
//


struct PatientDTO: Codable {
    let id: Int
    let email: String
    let cancer_type: String
    let urn: String
    let name: String
    let cycle_duration_days: Int
    let cycle_count: Int
    let treatment_start_date: String
    let sleep_percentage: Double
    let physiological_percentage: Double
    let patient_reported_percentage: Double
    let activity_percentage: Double
}