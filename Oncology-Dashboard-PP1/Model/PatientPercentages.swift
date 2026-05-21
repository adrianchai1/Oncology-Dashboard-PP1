//
//  PatientPerceentages.swift
//  Oncology-Dashboard-PP1
//
//  Created by Jonathan Dummett on 21/5/2026.
//

import Foundation

struct PatientPercentages: Codable, Equatable {
    let id: Int
    let date: Date
    let patientId: Int
    var physiological: Double?
    var activity: Double?
    var sleep: Double?
    var selfReported: Double?
}
