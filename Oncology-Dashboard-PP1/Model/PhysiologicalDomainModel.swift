//
//  PhysiologicalDomainModel.swift
//  Oncology-Dashboard-PP1
//
//  Created by Adrian Chai on 27/4/2026.
//  will pull data from DB here

import Foundation

struct PhysiologicalDomain: Codable {
    let restingHeartRate: Double
    let ambulatoryHeartRate: Double
    let derivedRespiratoryRate: Double
    let skinTemperature: Double
    
    
}
