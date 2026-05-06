//
//  GraphView.swift
//  Oncology-Dashboard-PP1
//
//  Created by Jonathan Dummett on 6/5/2026.
//

import SwiftUI
import Charts

struct GraphData: Identifiable {
    var id = UUID()
    var date: Date
    var data: Double
}

struct GraphView: View {
    
    var xLabel: String
    var yLabel: String
    
    var graphData: [GraphData] = []
    
    var body: some View {
        Chart {
            ForEach(graphData) { data in
                BarMark(
                    x: .value("Date", data.date),
                    y: .value("Total Count", data.data)
                )
            }
        }
    }
}



#Preview {
    GraphView(
        xLabel: "Date",
        yLabel: "Test",
        graphData: [
            GraphData(date: Date(), data: 12),
            GraphData(date: Date(), data: 19),
            GraphData(date: Date(), data: 16),
            GraphData(date: Date(), data: 15),
            GraphData(date: Date(), data: 13)
        ]
    )
}
