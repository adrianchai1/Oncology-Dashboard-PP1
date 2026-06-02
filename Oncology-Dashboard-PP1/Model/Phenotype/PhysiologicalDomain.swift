//
//  PhysiologicalDomainModel.swift
//  Oncology-Dashboard-PP1
//
//  Created by Adrian Chai on 27/4/2026.
//  will pull data from DB here

import Foundation

struct PhysiologicalDomain: Codable {
    let id: Int
    let userId: Int
    let date: Date
    let type: String
    let value: Double
    
    var toString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return "\(formatter.string(from: date)) \(type): \(value)"
    }
}
