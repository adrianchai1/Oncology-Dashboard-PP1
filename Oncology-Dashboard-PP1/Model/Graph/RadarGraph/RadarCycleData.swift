//
//  RadarCycleData.swift
//  Oncology-Dashboard-PP1
//
//  Created by Adrian Chai on 10/6/2026.
//

import Foundation

struct RadarCycleData: Identifiable {
    let id = UUID()
    let cycleNumber: Int
    let sleep: Double
    let physiological: Double
    let activity: Double
    let selfReported: Double
}
