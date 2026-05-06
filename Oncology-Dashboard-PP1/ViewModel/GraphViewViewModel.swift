//
//  GraphViewViewModel.swift
//  Oncology-Dashboard-PP1
//
//  Created by Jonathan Dummett on 6/5/2026.
//

import Foundation

func getTestGraphData() -> [GraphData] {
    var data: [GraphData] = []
    
    for i in (0..<14) {
        let newDate = Calendar.current.date(byAdding: .day, value: i, to: Date()) ?? Date()
        data.append(GraphData(date: newDate, data: Double.random(in: 10...30)))
    }
    
    return data
}
