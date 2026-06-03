//
//  MostConcerningMetrics.swift
//  Oncology-Dashboard-PP1
//
//  Created by Jonathan Dummett on 3/6/2026.
//

struct MostConcerningMetrics {
    let domain: String
    let type: String
    let data: [MetricData]
}

struct ConcernScore {
    let type: String
    let score: Double
    let reasons: [String]
}
