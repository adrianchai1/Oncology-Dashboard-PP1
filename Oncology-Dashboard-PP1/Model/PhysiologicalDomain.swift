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
}
