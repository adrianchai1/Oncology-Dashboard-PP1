//
//  GraphView.swift
//  Oncology-Dashboard-PP1
//
//  Created by Jonathan Dummett on 6/5/2026.
//

import SwiftUI
import Charts

// TODO: Add title

struct GraphView: View {
    
    var xLabel: String
    var yLabel: String
    var graphData: [GraphData] = []
    var color: Color?
    var showValueAboveBar: Bool = false
    
    var body: some View {
        Chart {
            ForEach(graphData) { data in
                BarMark(
                    x: .value("Date", data.date, unit: .day),
                    y: .value("Total Count", data.data)
                    
                )
                .foregroundStyle(color ?? Color.blue)
                .annotation(position: .top) {
                    if showValueAboveBar {
                        Text("\(data.data)")
                            .font(.system(size: 10))
                            .foregroundColor(.primary)
                    }
                }
                
            }
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .day)) { value in
                AxisValueLabel(
                    format: .dateTime.weekday(.narrow)
                )
            }
        }
        .padding(.horizontal)
    }
}



#Preview {
    GraphView(
        xLabel: "Date",
        yLabel: "Test",
        graphData: getTestGraphData(),
        color: Color.red,
        showValueAboveBar: true
    )
}
