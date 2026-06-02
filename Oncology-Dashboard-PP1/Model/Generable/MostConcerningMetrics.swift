//
//  Untitled.swift
//  Oncology-Dashboard-PP1
//
//  Created by Jonathan Dummett on 2/6/2026.
//

import FoundationModels

@Generable
struct MostConcerningMetrics {
    let mostConcern: [MostConcern]?
}

@Generable
struct MostConcern {
    let title: String
    let value: Double
    let unit: String
    let domain: String
    let date: String
    let good: Bool
}
