//
//  MoodDomainDTO.swift
//  Oncology-Dashboard-PP1
//
//  Created by Adrian Chai on 9/6/2026.
//


struct MoodDomainDTO: Codable {
    let entryid: Int
    let userid: Int
    let entry_date: String
    let mood: Int
}