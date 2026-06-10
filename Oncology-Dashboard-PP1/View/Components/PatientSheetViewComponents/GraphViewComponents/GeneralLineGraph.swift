//
//  LineGraph.swift
//  Oncology-Dashboard-PP1
//
//  Created by Jonathan Dummett on 20/5/2026.
//

import SwiftUI
import Charts



struct GeneralLineGraph: View {
    var dataPoints: [LinePoint]
    var color: Color
    
    var body: some View {
        
        Chart {
            ForEach(dataPoints, id: \.date) { dataPoint in
                LineMark(
                    x: .value("Date", dataPoint.date),
                    y: .value("Amount", max(-100, min(dataPoint.value, 100)))
                )
                .foregroundStyle(color)
                PointMark(
                    x: .value("Date", dataPoint.date),
                    y: .value("Amount", max(-100, min(dataPoint.value, 100)))
                )
                .symbol(Circle())
                .foregroundStyle(color)
            }
        }.chartYAxis {
            AxisMarks { value in
                AxisGridLine()
                AxisValueLabel()
                    .font(.system(size: 16, weight: .bold))
            }
        }
            
    }
}


#Preview {
    GeneralLineGraph(dataPoints: [
        LinePoint(date: Date().addingTimeInterval(-86400 * 9), value: 10),
        LinePoint(date: Date().addingTimeInterval(-86400 * 8), value: 15),
        LinePoint(date: Date().addingTimeInterval(-86400 * 7), value: 12),
        LinePoint(date: Date().addingTimeInterval(-86400 * 6), value: 13),
        LinePoint(date: Date().addingTimeInterval(-86400 * 5), value: 30),
        LinePoint(date: Date().addingTimeInterval(-86400 * 4), value: 5),
        LinePoint(date: Date().addingTimeInterval(-86400 * 3), value: -10),
        LinePoint(date: Date().addingTimeInterval(-86400 * 2), value: -30),
        LinePoint(date: Date().addingTimeInterval(-86400 * 1), value: -20),
        LinePoint(date: Date(), value: -15)
    ], color: Color.sleep)
    
}
