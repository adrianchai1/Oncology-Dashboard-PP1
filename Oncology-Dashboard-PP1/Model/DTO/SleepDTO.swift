//
//  SleepDTO.swift
//  Oncology-Dashboard-PP1
//
//  Created by Adrian Chai on 9/6/2026.
//

import Foundation

struct SleepDomainDTO: Codable {
    let userid: Int
    let entryid: Int
    let type: String
    let state: String
    let start_date: String
    let start_time: String
    let end_date: String
    let end_time: String
}
