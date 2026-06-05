//
//  SleepDomain.swift
//  Oncology-Dashboard-PP1
//
//  Created by Adrian Chai on 3/6/2026.
//

import Foundation

struct SleepDomain: Identifiable {
    let id: Int
    let userId: Int
    let type: String
    let state: String
    let startDate: Date
    let endDate: Date
}
