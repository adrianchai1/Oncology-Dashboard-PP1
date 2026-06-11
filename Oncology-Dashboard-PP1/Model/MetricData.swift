//
//  MetricData.swift
//  Oncology-Dashboard-PP1
//
//  Created by Jonathan Dummett on 11/6/2026.
//

import Foundation

struct MetricData {
    let date: Date
    let value: Double
    var deviationPercentage: Double = 0.0
    var type: String = ""
}
