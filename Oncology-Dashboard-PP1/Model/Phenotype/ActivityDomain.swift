//
//  ActivityDomain.swift
//  Oncology-Dashboard-PP1
//
//  Created by Jonathan Dummett on 21/5/2026.
//

import Foundation

struct ActivityDomain: Codable {
    let id: Int
    let userId: Int
    let date: Date
    let type: String
    let value: Double
}
