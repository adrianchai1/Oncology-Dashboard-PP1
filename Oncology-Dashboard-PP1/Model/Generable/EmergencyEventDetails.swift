//
//  EmergencyEventDetails.swift
//  Oncology-Dashboard-PP1
//
//  Created by Adrian Chai on 17/5/2026.
//

import FoundationModels

@Generable
struct EmergencyEventDetails {
    let reasonForVisit: String?
    let temperature: Double?
    let heartRate: Int?
    let bloodPressure: String?
    let spo2: Int?
    let painScore: Int?
    let interventions: [String]
    let treatments: [String]
}
