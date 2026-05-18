//
//  ChemotherapyEvent.swift
//  Oncology-Dashboard-PP1
//
//  Created by Adrian Chai on 17/5/2026.
//


struct ChemotherapyEvent: Identifiable {
    let id: Int
    let timelineEventId: Int
    let drugType: String
    let dosage: String
    let route: String
    let durationHours: Double
    let location: String
}