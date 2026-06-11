//
//  TimelineEventDTO.swift
//  Oncology-Dashboard-PP1
//
//  Created by Adrian Chai on 9/6/2026.
//


struct TimelineEventDTO: Codable {
    let id: Int
    let event_id: String
    let event_date: String
    let notes: String
    let doctor_id: String
    let title: String?
    let patient_id: Int
}