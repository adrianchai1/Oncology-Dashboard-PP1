//
//  Patient.swift
//  Oncology-Dashboard-PP1
//
//  Created by Adrian Chai on 3/5/2026.
//

import Foundation

struct Patient: Identifiable {
    let id: Int
    let urn: String
    let cancerType: String
    let patientName: String
    let treatmentStartDate: Date
    let cycleCount: Int
    let cycleLengthInDays: Int
    let sleepPercentage: Double
    let physiologicalPercentage: Double
    let patientReportedPercentage: Double
    let activityPercentage: Double
}
