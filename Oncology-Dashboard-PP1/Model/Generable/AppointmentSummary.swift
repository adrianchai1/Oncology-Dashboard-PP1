//
//  AppointmentSummary.swift
//  Oncology-Dashboard-PP1
//
//  Created by Adrian Chai on 17/5/2026.
//

import FoundationModels

@Generable
struct AppointmentSummary {
    let plan: String?
    let followUp: String?
    let keyFindings: [SummaryItem]?
}

@Generable
struct SummaryItem {
    let title: String
    let value: String
}
