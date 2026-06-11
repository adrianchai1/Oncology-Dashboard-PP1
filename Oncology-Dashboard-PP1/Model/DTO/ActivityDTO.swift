//
//  ActivityDTO.swift
//  Oncology-Dashboard-PP1
//
//  Created by Adrian Chai on 9/6/2026.
//

import Foundation

struct ActivityDomainDTO: Codable {
    let entryid: Int
    let userid: Int
    let date: String
    let type: String
    let value: Double
}
