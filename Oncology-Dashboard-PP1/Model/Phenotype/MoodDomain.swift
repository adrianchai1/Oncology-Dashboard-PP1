//
//  MoodDomain.swift
//  Oncology-Dashboard-PP1
//
//  Created by Adrian Chai on 9/6/2026.
//

import Foundation

struct MoodDomain: Codable {
    let id: Int
    let userId: Int
    let date: Date
    let mood: Int
}
