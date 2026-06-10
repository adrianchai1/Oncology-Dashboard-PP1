//
//  SleepScorePoint.swift
//  Oncology-Dashboard-PP1
//
//  Created by Adrian Chai on 10/6/2026.
//

import Foundation

struct SleepScorePoint: Identifiable {
    let id = UUID()
    let date: Date
    let score: Double
}
